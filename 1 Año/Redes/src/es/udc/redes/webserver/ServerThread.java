package es.udc.redes.webserver;

import java.net.*;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**A extends Thread class that receive petitions from a socket and send the response through the same socket.
 * It is thought to be used by a browser. It implements the HTTP 1.1 protocol.
 * @author 319
 * */

public class ServerThread extends Thread {
    private final Socket socket;

    BufferedReader in;
    DataOutputStream out;

    private final String root;
    private final String defaultFile;
    private final boolean allow;

    private Date modified_Since_Date;
    private int sentCode;
    private long tam;
    private String peticion;

    private String dinamicSol;
    private String listado;


    public ServerThread(Socket s, Properties configuracion) {
        // Store the socket s
        this.socket = s;

        root = configuracion.getProperty("BASE_DIRECTORY");
        defaultFile = configuracion.getProperty("DEFAULT_FILE");
        allow = Boolean.parseBoolean(configuracion.getProperty("ALLOW"));
    }


    /**
     * This method analyze the given file and build a string that contains the HTTP/1.1 state and head format.
     * @param url A path to a file (existent or not).
     * @return A string type with a HTTP/1.1 protocol format answer.
     */
    //Devolve o estado dunha peticion
    private String estadoAndCabeceira(String url){
        StringBuilder cadena = new StringBuilder();

        File ficheiro = new File(root + url);

        String name;

        //Estado
        if(ficheiro.exists()){
            if(ficheiro.canRead()){
                if(modified_Since_Date != null
                        && (ficheiro.lastModified()/1000 == modified_Since_Date.getTime()/1000)){

                    cadena.append("HTTP/1.1 304 Not Modified").append("\r\n");
                    sentCode = 304;
                    tam = 0;

                    //Fecha, hora actual e servidor
                    SimpleDateFormat format = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
                    String date = format.format(new Date());
                    cadena.append("Date: ").append(date).append("\r\n").append("Server: WebServer_319\r\n");
//                    log();
                    return cadena.toString();

                }else {
                    sentCode = 200;
                    cadena.append("HTTP/1.1 200 OK").append("\r\n");
                    name = url;
                }

            }else {
                cadena.append("HTTP/1.1 403 Forbidden").append("\r\n");
                name = "error/error403.html";
                ficheiro = new File(root + name);
                sentCode = 403;
            }

        }else{
            cadena.append("HTTP/1.1 404 Not Found").append("\r\n");
            name = "error/error404.html";
            ficheiro = new File(root + name);
            sentCode = 404;
        }

        cadena.append(cabeceira(name));

        return cadena.toString();
    }


    /**
     * This method analyze the given file and build a string that contains the HTTP/1.1 head format.
     * @param url A path to a file (it has to exist).
     * @return A string type with a HTTP/1.1 protocol format answer.
     */
    //Devolve a cabeceira dunha peticion
    private String cabeceira(String url) {
        File ficheiro = new File(root + url);

        StringBuilder cadena = new StringBuilder();

        //Fecha, hora actual e servidor
        SimpleDateFormat format = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
        String date = format.format(new Date());
        cadena.append("Date: ").append(date).append("\r\n").append("Server: WebServer_319").append("\r\n");

        //Fecha e hora da última modificación do ficheiro
        SimpleDateFormat format2 = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
        String lastModified = format2.format(new Date(ficheiro.lastModified()));
        cadena.append("Last-Modified: ").append(lastModified).append("\r\n");

        //Tamaño
        cadena.append("Content-Length: ").append(ficheiro.length()).append("\r\n");

        //Tipo
        cadena.append("Content-Type: ");

        if(ficheiro.getName().endsWith(".html")){
            cadena.append("text/html").append("\r\n");

        }else if(ficheiro.getName().endsWith(".txt")){
            cadena.append("text/plain").append("\r\n");

        }else if(ficheiro.getName().endsWith(".png")){
            cadena.append("image/png").append("\r\n");

        }else if(ficheiro.getName().endsWith(".gif")){
            cadena.append("image/gif").append("\r\n");

        }else{
            cadena.append("application/octet-stream").append("\r\n");
        }

        tam = ficheiro.length();
//        log();

        return cadena.toString();
    }


    /**
     * It opens a stream to a file, reads the content and write it in an output byte array stream.
     * Then return the array of bytes.
     * @param url A path to a file (it has to exist).
     * @return A array of bytes that contains a image or text file content.
     * @throws IOException It throws a exception if the file reader stream can't be open.
     */
    //Abre e le o ficheiro solicitado
    private byte[] entidade(String url) throws IOException {
        int bite;
        ByteArrayOutputStream temp;

        File ficheiro = new File(root + url);

        String nome;

        if (ficheiro.exists()) {
            if (ficheiro.canRead()) {
                nome = root + url;
            } else {
                nome = root + "error/error403.html";
            }
        } else {
            nome = root + "error/error404.html";
        }

        try {
            BufferedInputStream fileReader =
                    new BufferedInputStream(new FileInputStream(nome));
            temp = new ByteArrayOutputStream();

            while((bite = fileReader.read()) != -1){
                temp.write(bite);
            }
            fileReader.close();
            return temp.toByteArray();

        }catch (IOException ex){
            throw new IOException(ex);
        }
    }


    /**
     * After the method is running, it writes in an error file or in an access file information
     * about the answer sent through the socket. The write file depends on the type of the sent state.
     * It writes:
     *   Petition type
     *   IP address
     *   Date
     *   State code (if it's access)
     *   Size (if it's access)
     *   Error code (if it's error)
     */
    private void log(){
        FileWriter stream;

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss z");
        try {
            if (sentCode == 200 || sentCode == 304) {
                stream = new FileWriter(root + "log/access.log", true);
                stream.append("Petition: ").append(peticion).append("\n");
                stream.append("IP address: ").append(socket.getInetAddress().getHostAddress()).append("\n");
                stream.append("Date: ").append(sdf.format(new Date())).append("\n");
                stream.append("State code: ").append(String.valueOf(sentCode)).append("\n");
                stream.append("Size: ").append(String.valueOf(tam)).append("\n");

            } else {
                stream = new FileWriter(root + "log/error.log",true);
                stream.append("Petition: ").append(peticion).append("\n");
                stream.append("IP adress: ").append(socket.getInetAddress().getHostAddress()).append("\n");
                stream.append("Date: ").append(sdf.format(new Date())).append("\n");
                stream.append("Error code: ").append(String.valueOf(sentCode)).append("\n");
            }
            stream.append("\n\n\n");
            stream.flush();
            stream.close();

        } catch (IOException ignored) {}
    }


    /**
     * Reads the parameters of a HTTP 1.1 dynamic request and execute the appropriate class.
     * @param url A path with parameters and a name of a servlet class.
     * @return A string type with a HTTP/1.1 protocol format answer.
     */
    private String dinamicPage(String url){
        //Direccion do servlet
        String servlet = "es.udc.redes.webserver."
                + url.substring(url.lastIndexOf('/') + 1, url.lastIndexOf('.'));

        //Cadena cos datos
        String StringDatos = url.substring(url.lastIndexOf('?') + 1);

        //Trocéanse os datos separados por '&'
        String[] trozosDatos = StringDatos.split("&");

        //"Mapeanse" os datos
        Map<String, String> datos = new Hashtable<>();
        for (String i : trozosDatos) {
            datos.put(i.substring(0, i.indexOf('=')), i.substring(i.indexOf('=') + 1));
        }

        //Executar o servlet e obter a resposta
        try {
            dinamicSol = ServerUtils.processDynRequest(servlet, datos);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return specialCabeceiraAndHead(dinamicSol);
    }

    /**
     * Build a html string type with the entries that the directory contains.
     * @param url A path directory name.
     * @return A string type with a HTTP/1.1 protocol format answer.
     */
    private String allow(String url){
        File directorio = new File((root + url));
        String[] entradas = directorio.list();

        StringBuilder sb = new StringBuilder();

        try {
            sb.append("<html><head><title>Directory List</title></head><body>");
            for (String e : entradas) {
                sb.append("<h4><a href=\"" + e + "\">" + e + "</a></h4>");
            }
            sb.append("</body></html>");

            listado = sb.toString();

        } catch (Exception ignore) {}

        return specialCabeceiraAndHead(listado);
    }


    /**
     * This method build a string that contains the HTTP/1.1 state and head format. It not analyze any file.
     * Only build the string with the 200 response.
     * @param name A String with a answer information.
     * @return A string type with a HTTP/1.1 protocol format answer.
     */
    private String specialCabeceiraAndHead(String name){
        StringBuilder cadena = new StringBuilder();

        //Estado
        cadena.append("HTTP/1.1 200 OK").append("\r\n");
        sentCode = 200;

        //Cabeceira
        SimpleDateFormat format = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
        String date = format.format(new Date());
        cadena.append("Date: ").append(date).append("\r\n").append("Server: WebServer_319").append("\r\n");

        //Tamaño
        cadena.append("Content-Length: ").append(name.length()).append("\r\n");

        //Tipo
        cadena.append("Content-Type: ").append("text/html").append("\r\n");

        tam = name.length();
//        log();

        return cadena.toString();
    }


    /**
     * Opens the input and output streams, receive the request, split the petition, analyze it and
     * send the response through the socket.
     */
    @Override
    public void run() {
        String line;
        ArrayList<String> heads = new ArrayList<>();

        try {
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new DataOutputStream(socket.getOutputStream());

            // This code processes HTTP requests and generates

            //Lectura e troceado da línea de peticion
            peticion = in.readLine();

            String[] trozos = peticion.split(" ");
            //método = trozos[0]
            //url = trozos[1]
            //http = trozos[2]


            //Lectura das lineas de cabeceira e almacenamento
            line = in.readLine();
            while(!line.equals("")){
                heads.add(line);
                if(line.startsWith("If-Modified-Since:")) {
                    SimpleDateFormat format = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss zzzz");
                    try {
                        modified_Since_Date = format.parse(line.substring(line.indexOf(':') + 2));
                    } catch (ParseException ignored) {}
                }
                line = in.readLine();
            }


            //Enviar lineas cabeceira e estado
            if(trozos.length == 3 && (trozos[0].equals("GET") || trozos[0].equals("HEAD"))){
                if(trozos[1].contains(".do")) {
                    out.write(dinamicPage(trozos[1]).getBytes());     //lineas estado e cabeceiras
                    out.write("\r\n".getBytes());            //linea en blanco
                    out.write(dinamicSol.getBytes());   //corpo da entidade

                } if(trozos[1].endsWith("/") && allow &&
                        !(new File((root + trozos[1]) + defaultFile).exists())){
                    //Enviamos estado y cabeceras
                    out.write(allow(trozos[1]).getBytes());
                    //Línea en blanco
                    out.write("\r\n".getBytes());
                    //Enviar cuerpo con el contenido dinámico
                    out.write(listado.getBytes());

                }else{
                    if (trozos[1].endsWith("/")) trozos[1] = defaultFile;
                    //Enviar linea cabeceira e estado
                    out.write(estadoAndCabeceira(trozos[1]).getBytes());     //lineas estado e cabeceiras
                    out.write("\r\n".getBytes());                            //linea en blanco
                    if(trozos[0].equals("GET")){                             //No caso de GET
                        out.write(entidade(trozos[1]));                      //corpo da entidade
                    }
                }

            }else{
                //Petición con menos de 3 trozos ou método distinto de GET e HEAD
                sentCode = 400;
                out.write("HTTP/1.1 400 Bad Request\r\n".getBytes());
                out.write(cabeceira("error/error400.html").getBytes());
                out.write("\r\n".getBytes());
                out.write(entidade("error/error400.html"));
            }

            out.flush();

        } catch (SocketTimeoutException e) {
            System.err.println("Nothing received in 300 secs");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}
