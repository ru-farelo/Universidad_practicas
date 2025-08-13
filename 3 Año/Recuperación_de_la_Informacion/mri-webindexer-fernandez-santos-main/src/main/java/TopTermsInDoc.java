import org.apache.lucene.index.*;
import org.apache.lucene.search.*;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.BytesRef;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class TopTermsInDoc {

    public static void main(String[] args) {
        String indexPath = null;
        String fieldName = null;
        int docID = -1;
        int topN = -1;
        String outFile = null;
        String url = null;

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
                case "-docID":
                    docID = Integer.parseInt(args[++i]);
                    break;
                case "-url":
                    url = args[++i];
                    break;
                default:
                    System.out.println("Argumento no reconocido: " + args[i]);
                    System.exit(1);
            }
        }
        String Usage = "Usage: TopTermsInDoc -index path -field campo -top n -outfile path -url path";
        if (indexPath == null || fieldName == null || topN == -1 || outFile == null) {
            throw new IllegalArgumentException(Usage);
        }

        // Si se proporciona la url, buscar el docID
        if (url != null) {
            try {
                IndexSearcher searcher = new IndexSearcher(DirectoryReader.open(FSDirectory.open(Paths.get(indexPath))));
                Query query = new TermQuery(new Term("url", url));
                TopDocs topDocs = searcher.search(query, 1);
                ScoreDoc[] scoreDocs = topDocs.scoreDocs;
                if (scoreDocs.length > 0) {
                    docID = scoreDocs[0].doc;
                } else {
                    System.out.println("No se encontró el documento con la url: " + url);
                    System.exit(1);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        try (IndexReader indexReader = DirectoryReader.open(FSDirectory.open(Paths.get(indexPath)))) {
            TermVectors termVectors=indexReader.termVectors();
            Terms terms=termVectors.get(docID, fieldName);

            // Lista para almacenar los términos y sus valores tfidf
            List<Termino> terminoList = new ArrayList<>();

            if (terms != null) {
                TermsEnum termsEnum = terms.iterator();
                while (termsEnum.next() != null) {
                    // Calcular termino
                    String term= termsEnum.term().utf8ToString();
                    // Calcular TF
                    int tf = (int) termsEnum.totalTermFreq();
                    // Calcular DF
                    int df = indexReader.docFreq(new Term(fieldName, term));
                    // Calcular idf
                    double idf = Math.log10((double) indexReader.numDocs() / (double) df);
                    // Calcular tfidf
                    double tfidf = tf * idf;
                    terminoList.add(new Termino(term, tfidf, df, tf));
                }
            }

            // Ordenar los términos por tfidf
            terminoList.sort(Comparator.comparingDouble(Termino::getTfidf).reversed());

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(outFile))) {
                System.out.printf("Documento: %d%n", docID);
                writer.write(String.format("Documento: %d%n", docID));
                // Presentar los top N términos
                for (int i = 0; i < Math.min(topN, terminoList.size()); i++) {
                    Termino termino = terminoList.get(i);
                    // Imprimir resultados por pantalla
                    System.out.printf("Term: %s, TF: %d, DF: %d, TF x IDFlog10: %.2f%n",
                            termino.getTerm(), termino.getTf(), termino.getDf(), termino.getTfidf());
                    // Escribir resultados en el archivo
                    writer.write(String.format("Term: %s, TF: %d, DF: %d, TF x IDFlog10: %.2f%n",
                            termino.getTerm(), termino.getTf(), termino.getDf(), termino.getTfidf()));
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
        private final double tfidf;
        private final int tf;
        private final int df;

        public Termino(String term, double tfidf, int df, int tf) {
            this.term = term;
            this.tfidf = tfidf;
            this.df = df;
            this.tf = tf;
        }

        public String getTerm() {return term;}
        public double getTfidf() {return tfidf;}
        public int getTf() {return tf;}
        public int getDf() {return df;}
    }
}
