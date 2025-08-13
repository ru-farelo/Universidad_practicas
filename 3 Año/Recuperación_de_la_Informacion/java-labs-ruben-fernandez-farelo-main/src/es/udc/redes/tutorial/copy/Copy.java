package es.udc.redes.tutorial.copy;
import java.io.*;

public class Copy {
    public static void main(String[] args){

        if (args.length != 2) {
            System.err.println("Format: es.udc.redes.tutorial.copy.Copy <origin> <destiny>");
            System.exit(-1);
        }

        File origen = new File(args[0]);
        File destino = new File(args[1]);
        if (origen.exists()) {
            try {
                InputStream in = new FileInputStream(origen);
                OutputStream out = new FileOutputStream(destino);
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                in.close();
                out.close();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }
}

