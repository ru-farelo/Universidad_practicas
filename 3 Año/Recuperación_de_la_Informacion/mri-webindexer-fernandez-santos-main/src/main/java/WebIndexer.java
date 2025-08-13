import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.es.SpanishAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.*;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.jsoup.Jsoup;

import java.io.*;
import java.net.InetAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileTime;
import java.time.Duration;
import java.util.Arrays;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;


public class WebIndexer {

    public static void main(String[] args) throws IOException{
        // Configuración inicial y argumentos aquí...

        String indexPath = null;
        String docsPath = null;
        boolean create = false;
        int numThreads = Runtime.getRuntime().availableProcessors();
        boolean h = false;
        boolean p = false;
        boolean titleTermVectors = false;
        boolean bodyTermVectors = false;
        String analyzer = "Standard";
        String onlyDoms;

        for (int i = 0; i < args.length; i++) {
            switch (args[i]){
                case "-index":   //-Con -index INDEX_PATH, se indica la carpeta donde se almacenará el índice
                    indexPath = args[++i];
                    break;
                case "-docs":    // -Con -docs DOCS_PATH, se indica la carpeta donde se almacenan los archivos .loc y .loc.notags
                    docsPath = args[++i];
                    break;
                case "-create":  // -Si se usa -create, el índice se abre con CREATE, por defecto con CREATE_OR_APPEND
                    create = true;
                    break;
                case "-numThreads": // -Con -numThreads NUM_THREADS, se indica el número de hilos a usar
                    numThreads = Integer.parseInt(args[++i]);
                    break;
                case "-h":  // -Con -h, cada hilo informará del comienzo y fin de su trabajo: «Hilo xxx comienzo url yyy» «Hiloxxx fin url yyy»
                    h = true;
                    break;
                case "-p":  // -Con -p, la aplicación informará del fin de su trabajo: «Creado índice zzz en mmm msecs»
                    p = true;
                    break;
                case "-titleTermVectors":   // -Con -titleTermVectors, se indicará que el campo title debe almacenar Term Vectors.
                    titleTermVectors = true;
                    break;
                case "-bodyTermVectors":    // -Con -bodyTermVectors, se indicará que el campo body debe almacenar Term Vectors.
                    bodyTermVectors = true;
                    break;
                case "-analyzer":   // -Con -analyzer Analyzer, se indicará que se use uno de los Analyzers ya proporcionados porLucene, por defecto se usará el Standard Analyzer
                    analyzer = args[++i];
                    break;
                default:
                    throw new IllegalArgumentException("unknown parameter " + args[i]);
            }
        }

        Properties properties = new Properties();
        try{
            // Cargar el archivo config.properties desde la carpeta resources
            properties.load(new FileInputStream("src/main/resources/config.properties"));
        }catch (IOException e){
            e.printStackTrace();
        }
        onlyDoms=properties.getProperty("onlyDoms");

        String Usage = "Usage: WebIndexer [-index INDEX_PATH] [-docs DOCS_PATH] [-create] [-numThreads NUM_THREADS] [-h] [-p] [-titleTermVectors] [-bodyTermVectors] [-analyzer Analyzer (Standard, English o Spanish)]";
        if (indexPath == null || docsPath == null) {
            throw new IllegalArgumentException(Usage);
        }

        // Indexar con Lucene
        Directory indexDir = FSDirectory.open(Paths.get(indexPath));
        Analyzer analyzerInstance ;
        // Seleccionar el Analyzer
        switch (analyzer) {
            case "Standard":
                analyzerInstance = new StandardAnalyzer();
                break;
            case "English":
                analyzerInstance = new EnglishAnalyzer();
                break;
            case "Spanish":
                analyzerInstance = new SpanishAnalyzer();
                break;
            default:
                throw new IllegalArgumentException("[-analyzer Analyzer (Standard, English o Spanish)]");
        }
        // Configurar el IndexWriter
        IndexWriterConfig config = new IndexWriterConfig(analyzerInstance);
        if (create) {
            config.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
        } else {
            config.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
        }
        // Crear el IndexWriter
        IndexWriter writer = new IndexWriter(indexDir, config);

        // Cada hilo procesará un archivo .url
        ExecutorService executor = Executors.newFixedThreadPool(numThreads);
        // Se procesarán todos los archivos .url de la carpeta indicada

        // Se procesarán todos los archivos .url de la carpeta indicada
        Path urlsDir = Paths.get("./src/test/resources/urls");
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(urlsDir, "*.url")) {
            for (Path urlFile : stream) {
                // Cada hilo procesará un archivo .url
                executor.execute(new UrlProcessor(writer, urlFile, docsPath, h, titleTermVectors, bodyTermVectors, onlyDoms));
            }
        }

        // Esperar a que terminen todos los hilos
        if (p) {
            // Medir tiempo de ejecución
            long startTime = System.currentTimeMillis();
            executor.shutdown();
            try {
                executor.awaitTermination(1, TimeUnit.HOURS);
            } catch (final InterruptedException e) {
                e.printStackTrace();
                System.exit(-2);
            }
            long endTime = System.currentTimeMillis();
            System.out.println("Creado índice " + indexPath + " en " + (endTime - startTime) + " msecs");
        } else {
            // No medir tiempo de ejecución
            executor.shutdown();
            try {
                executor.awaitTermination(1, TimeUnit.HOURS);
            } catch (final InterruptedException e) {
                e.printStackTrace();
                System.exit(-2);
            }
        }

        try {
            writer.commit();
            writer.close();
        } catch (CorruptIndexException e) {
            System.out.println("Graceful message: exception " + e);
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("Graceful message: exception " + e);
            e.printStackTrace();
        }
        indexDir.close();
    }


    static class UrlProcessor implements Runnable {
        private final IndexWriter writer;
        private final Path urlFile;
        private final String docsPath;
        private final boolean h;
        private final boolean titleTermVectors;
        private final boolean bodyTermVectors;
        private final String onlyDoms;

        public UrlProcessor(IndexWriter writer, Path urlFile, String docsPath, boolean h, boolean titleTermVectors, boolean bodyTermVectors, String onlyDoms) {
            this.writer = writer;
            this.urlFile = urlFile;
            this.docsPath = docsPath;
            this.h = h;
            this.titleTermVectors = titleTermVectors;
            this.bodyTermVectors = bodyTermVectors;
            this.onlyDoms = onlyDoms;
        }

        @Override
        public void run() {
            try {

                if (h) {
                    // Informar del comienzo del trabajo
                    System.out.println("Hilo " + Thread.currentThread().getName() + " comienzo url " + urlFile.getFileName());
                }
                // Procesar el archivo .url
                processUrlFile();
                if (h) {
                    // Informar del fin del trabajo
                    System.out.println("Hilo " + Thread.currentThread().getName() + " fin url " + urlFile.getFileName());
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        private void processUrlFile() throws IOException, InterruptedException {
            try (BufferedReader reader = Files.newBufferedReader(urlFile)) {
                String line;
                // Procesar cada línea del archivo .url
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("http://") || line.startsWith("https://")) {
                        // Verificar si la URL contiene alguno de los dominios especificados en onlyDoms
                        boolean isValidDomain = Arrays.stream(onlyDoms.split(" ")).anyMatch(line::endsWith);
                        if(isValidDomain){
                            processUrl(line);
                        }
                    }
                }
            }
        }

        private void processUrl(String url) throws IOException, InterruptedException {
            HttpClient client = HttpClient.newBuilder()
                    .followRedirects(HttpClient.Redirect.NORMAL) // Configurar para seguir redirecciones
                    .connectTimeout(Duration.ofSeconds(5)) // Establecer timeout de conexión
                    .build();
            // Realizar petición HTTP GET
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).timeout(Duration.ofSeconds(10)).build(); //timeout establece timeout de respuesta
            // Obtener respuesta
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Si la respuesta es 200, almacenar en archivos .loc y .loc.notags y indexar con Lucene
            if (response.statusCode() == 200) {
                String content = response.body();
                org.jsoup.nodes.Document doc = Jsoup.parse(content);
                String title = doc.title();
                String body = doc.body().text();

                // Almacenar en archivos .loc y .loc.notags
                String fileName = url.replace("http://", "").replace("https://", "");
                Path locFile = Paths.get(docsPath, fileName + ".loc");
                Path locNotagsFile = Paths.get(docsPath, fileName + ".loc.notags");

                // Crear directorio si no existe
                try (BufferedWriter locWriter = Files.newBufferedWriter(locFile);
                     BufferedWriter locNotagsWriter = Files.newBufferedWriter(locNotagsFile)) {
                    locWriter.write(content);
                    locNotagsWriter.write(title + "\n" + body);
                }



                try (InputStream stream = Files.newInputStream(locFile)) {
                    // Crear el documento Lucene
                    Document luceneDoc = new Document();

                    // Añadir campos al documento Lucene
                    luceneDoc.add(new KeywordField("path", locFile.toString(), Field.Store.YES));
                    luceneDoc.add(new TextField("contents", new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))));
                    luceneDoc.add(new StringField("hostname", InetAddress.getLocalHost().getHostName(), Field.Store.YES));
                    luceneDoc.add(new StringField("thread", Thread.currentThread().getName(), Field.Store.YES));
                    luceneDoc.add(new StringField("locKb", String.valueOf(Files.size(locFile) / 1024), Field.Store.YES));
                    luceneDoc.add(new StringField("notagsKb", String.valueOf(Files.size(locNotagsFile) / 1024), Field.Store.YES));
                    BasicFileAttributes attr = Files.readAttributes(locFile, BasicFileAttributes.class);
                    FileTime creationTime = attr.creationTime();
                    FileTime lastAccessTime = attr.lastAccessTime();
                    FileTime lastModifiedTime = attr.lastModifiedTime();
                    luceneDoc.add(new StringField("creationTime", creationTime.toString(), Field.Store.YES));
                    luceneDoc.add(new StringField("lastAccessTime", lastAccessTime.toString(), Field.Store.YES));
                    luceneDoc.add(new StringField("lastModifiedTime", lastModifiedTime.toString(), Field.Store.YES));
                    luceneDoc.add(new StringField("creationTimeLucene", DateTools.dateToString(new Date(creationTime.toMillis()), DateTools.Resolution.SECOND), Field.Store.YES));
                    luceneDoc.add(new StringField("lastAccessTimeLucene", DateTools.dateToString(new Date(lastAccessTime.toMillis()), DateTools.Resolution.SECOND), Field.Store.YES));
                    luceneDoc.add(new StringField("lastModifiedTimeLucene", DateTools.dateToString(new Date(lastModifiedTime.toMillis()), DateTools.Resolution.SECOND), Field.Store.YES));

                    // Agregar campo URL al índice
                    luceneDoc.add(new StringField("url", url, Field.Store.YES));


                    FieldType titleType = new FieldType();
                    titleType.setStored(true);
                    titleType.setIndexOptions(IndexOptions.DOCS_AND_FREQS_AND_POSITIONS);
                    titleType.setTokenized(true);
                    if (titleTermVectors) {
                        titleType.setStoreTermVectors(true); // Habilitar term vectors
                    }
                    titleType.freeze();
                    luceneDoc.add(new Field("title", title, titleType));

                    FieldType bodyType = new FieldType();
                    bodyType.setStored(true);
                    bodyType.setIndexOptions(IndexOptions.DOCS_AND_FREQS_AND_POSITIONS);
                    bodyType.setTokenized(true);
                    if (bodyTermVectors) {
                        bodyType.setStoreTermVectors(true); // Habilitar term vectors
                    }
                    bodyType.freeze();
                    luceneDoc.add(new Field("body", body, bodyType));

                    // Escribir el documento Lucene en el índice
                    try {
                        writer.addDocument(luceneDoc);
                    } catch (CorruptIndexException e) {
                        System.out.println("Graceful message: exception " + e);
                        e.printStackTrace();
                    } catch (IOException e) {
                        System.out.println("Graceful message: exception " + e);
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
