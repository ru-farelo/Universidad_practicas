package es.udc.redes.tutorial.udp.server;

import java.net.*;

/**
 * Implements a UDP echo server.
 */
public class UdpServer {

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.err.println("Format: es.udc.redes.tutorial.udp.server.UdpServer <port_number>");
            System.exit(-1);
        }
        DatagramSocket socket = null;
        try {
            // Create a server socket
            socket = new DatagramSocket(Integer.parseInt(argv[0]));
            // Set maximum timeout to 300 secs
            socket.setSoTimeout(300000);
            DatagramPacket packet;
            String m;
            while (true) {
                // Prepare datagram for reception
                byte[] buffer = new byte[1024];
                packet = new DatagramPacket(buffer, buffer.length);
                // Receive the message
                socket.receive(packet);
                // Prepare datagram to send response
                m = new String(buffer);
                System.out.println("SERVER: Received "
                        + m + " from " + packet.getAddress() + ":" + packet.getPort());

                // Send response
                socket.send(packet);
                System.out.println("SERVER: Sending "
                        + m + " to " + packet.getAddress() + ":" + packet.getPort());

            }
          
        // Uncomment next catch clause after implementing the logic
        } catch (SocketTimeoutException e) {
           System.err.println("No requests received in 300 secs ");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        // Close the socket
            socket.close();
        }
    }
}
