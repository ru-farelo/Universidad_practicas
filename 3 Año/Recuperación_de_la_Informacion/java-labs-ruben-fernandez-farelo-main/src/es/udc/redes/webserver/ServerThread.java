package es.udc.redes.webserver;

import java.net.*;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


public class ServerThread extends Thread {
    private final Socket socket;

    BufferedReader in;
    DataOutputStream out;

    private final String root;
    private final String defaultFile;

    private Date modified_Since_Date;
    private int sentCode;
    private long tam;
    private String peticion;


    public ServerThread(Socket s, Properties configuracion) {
        // Store the socket s
        this.socket = s;

        root = configuracion.getProperty("BASE_DIRECTORY");
        defaultFile = configuracion.getProperty("DEFAULT_FILE");
    }


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

        return cadena.toString();
    }

    private String estadoAndCabeceira(String url){
        StringBuilder cadena = new StringBuilder();

        File ficheiro = new File(root + url);

        String name = "";

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
                    return cadena.toString();

                }else {
                    sentCode = 200;
                    cadena.append("HTTP/1.1 200 OK").append("\r\n");
                    name = url;
                }

            }

        }

        else{
            cadena.append("HTTP/1.1 404 Not Found").append("\r\n");
            name = "error/error404.html";
            ficheiro = new File(root + name);
            sentCode = 404;
        }

        cadena.append(cabeceira(name));

        return cadena.toString();
    }

    @Override
    public void run() {
        String line;
        ArrayList<String> heads = new ArrayList<>();

        try {
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new DataOutputStream(socket.getOutputStream());

            //Lectura e troceado da línea de peticion
            peticion = in.readLine();

            String[] trozos = peticion.split(" ");

            //Lectura das lineas de cabeceira e almacenamento
            line = in.readLine();

            while(!line.equals("")){
                heads.add(line);
                //Modified
                if(line.startsWith("If-Modified-Since:")) {
                    SimpleDateFormat format = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss zzzz");
                    try {
                        modified_Since_Date = format.parse(line.substring(line.indexOf(':') + 2));
                    } catch (ParseException ignored) {}
                }
                line = in.readLine();
            }
            //Enviar lineas cabeceira e estado
            if(trozos.length == 3 && (
//                    trozos[0].equals("GET") ||
                    trozos[0].equals("HEAD"))
            ){

                if (trozos[1].endsWith("/")) trozos[1] = defaultFile;

                //Enviar linea cabeceira e estado
                out.write(estadoAndCabeceira(trozos[1]).getBytes());     //lineas estado e cabeceiras
                out.write("\r\n".getBytes());                            //linea en blanco

               if(trozos[0].equals("GET")){                             //No caso de GET
                    out.write(entidade(trozos[1]));                      //corpo da entidade
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
