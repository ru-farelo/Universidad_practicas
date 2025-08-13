package es.udc.redes.tutorial.tcp.server;
import java.net.*;
import java.io.*;

/** Thread that processes an echo server connection. */

public class ServerThread extends Thread {

  private final Socket socket;
  private BufferedReader in;
  private PrintWriter out;
  private String m;

  public ServerThread(Socket s) {
    // Store the socket s
      socket = s;
  }

@Override
  public void run() {
      try {
          // Set the input channel
          in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

          // Set the output channel
          out = new PrintWriter(socket.getOutputStream(), true);

          // Receive the message from the client
          m = in.readLine();
          System.out.println("SERVER: Received "
                + m + " from " + socket.getInetAddress() + ":" + socket.getPort());

          // Sent the echo message to the client
          out.println(m);
          System.out.println("SERVER: Sending "
                + m + " to " + socket.getInetAddress() + ":" + socket.getPort());

          // Close the streams
          out.close();
          in.close();

      } catch (SocketTimeoutException e) {
      System.err.println("Nothing received in 300 secs");

      } catch (Exception e) {
      System.err.println("Error: " + e.getMessage());

      } finally {
        // Close the socket
          try {
              socket.close();
          } catch (IOException e) {
              e.printStackTrace();
          }
      }
  }
}
