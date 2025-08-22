package es.udc.redes.webserver;

import java.io.FileReader;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.Properties;

/**
 * Server that receives petitions through a port.
 * @author 319
 * */

public class WebServer {

    /**
     * Opens a properties file, see the content, listens in the given port and start a thread for each
     * request. Stop listening when 300 seconds have passed and close the server.
     */
    public static void main(String[] args) {
        ServerSocket server = null;
        Socket socket;

        Properties conf = new Properties();

        int port = 1111;

        try{
            conf.load(new FileReader("p1-files/server.properties"));
            port = Integer.parseInt(conf.getProperty("PORT"));
        }catch (IOException ignore){}

        try {
            // Create a server socket
            server = new ServerSocket(port);

            // Set a timeout of 300 secs
            server.setSoTimeout(300000);

            ServerThread thread;

            while (true) {
                // Wait for connections
                socket = server.accept();

                // Create a ServerThread object, with the new connection as parameter
                thread = new ServerThread(socket, conf);

                // Initiate thread using the start() method
                thread.start();

            }

        } catch (SocketTimeoutException e) {
            System.err.println("Nothing received in 300 secs");

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();

        } finally{
            try {
                server.close();

            } catch (IOException e){
                e.printStackTrace();
            }
        }
    }
}
