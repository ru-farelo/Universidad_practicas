package es.udc.redes.tutorial.tcp.server;

import java.net.*;
import java.io.*;

/**
  MonoThread TCP echo server.
 */
public class MonoThreadTcpServer {

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.err.println("Format: es.udc.redes.tutorial.tcp.server.MonoThreadTcpServer <port>");
            System.exit(-1);
        }
        ServerSocket server = null;
        Socket socket = null;
        try {
            // Create a server socket

            server = new ServerSocket(Integer.parseInt(argv[0]));
            // Set a timeout of 300 secs
            server.setSoTimeout(300000);
            BufferedReader in;
            PrintWriter out;
            String m;
            while (true) {
                // Wait for connections
                socket = server.accept();
                // Set the input channel
                in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                // Set the output channel
                out = new PrintWriter(socket.getOutputStream(),true);
                // Receive the client message
                m = in.readLine();
                System.out.println("SERVER: Received "
                        + m + " from " + socket.getInetAddress() + ":" + socket.getPort());

                // Send response to the client
                out.println(m);
                System.out.println("SERVER: Sending "
                        + m + " to " + socket.getInetAddress() + ":" + socket.getPort());


                // Close the streams
                in.close();
                out.close();
            }
        // Uncomment next catch clause after implementing the logic            
        //} catch (SocketTimeoutException e) {
        //    System.err.println("Nothing received in 300 secs ");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
	        //Close the socket
            server.close();
            socket.close();

        }catch (IOException e){
            e.printStackTrace();
            }
        }
    }
}
