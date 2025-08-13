import org.apache.lucene.index.*;
import org.apache.lucene.store.FSDirectory;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class TopTermsInField {

    public static void main(String[] args) {
        String indexPath = null;
        String fieldName = null;
        int topN = -1;
        String outFile = null;

        for (int i = 0; i < args.length; i++) {
            switch (args[i]) {
                case "-index":
                    indexPath = args[++i];
                    break;
                case "-field":
                    fieldName = args[++i];
                    break;
                case "-top":
                    topN = Integer.parseInt(args[++i]);
                    break;
                case "-outfile":
                    outFile = args[++i];
                    break;
                default:
                    System.out.println("Argumento no reconocido: " + args[i]);
                    System.exit(1);
            }
        }
        String Usage = "Usage: TopTermsInField -index path -field campo -top n -outfile path";
        if (indexPath == null || fieldName == null || topN == -1 || outFile == null) {
            throw new IllegalArgumentException(Usage);
        }

        try (IndexReader indexReader = DirectoryReader.open(FSDirectory.open(Paths.get(indexPath)))) {

            // Lista para almacenar los términos y sus valores df
            List<Termino> terminoList = new ArrayList<>();

            Terms terms = MultiTerms.getTerms(indexReader, fieldName);

            if (terms != null) {
                TermsEnum termsEnum = terms.iterator();
                while (termsEnum.next() != null) {
                    // Calcular termino
                    String term = termsEnum.term().utf8ToString();
                    // Calcular DF
                    int df = indexReader.docFreq(new Term(fieldName, term));
                    terminoList.add(new Termino(term, df));
                }
            }

            // Ordenar los términos por df
            terminoList.sort(Comparator.comparingInt(Termino::getDf).reversed());

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(outFile))) {
                writer.write(String.format("Top %d términos en el campo '%s'%n", topN, fieldName));
                System.out.printf("Top %d términos en el campo '%s'%n", topN, fieldName);
                // Presentar los top N términos
                for (int i = 0; i < Math.min(topN, terminoList.size()); i++) {
                    Termino termino = terminoList.get(i);
                    // Imprimir resultados por pantalla
                    System.out.printf("Term: %s, DF: %d%n", termino.getTerm(), termino.getDf());
                    // Escribir resultados en el archivo
                    writer.write(String.format("Term: %s, DF: %d%n", termino.getTerm(), termino.getDf()));
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static class Termino {
        private final String term;
        private final int df;

        public Termino(String term, int df) {
            this.term = term;
            this.df = df;
        }

        public String getTerm() {return term;}
        public int getDf() {return df;}
    }
}
