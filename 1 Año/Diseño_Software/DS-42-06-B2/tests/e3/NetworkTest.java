package e3;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class NetworkTest {

    List<String> usuarios = new ArrayList<>();
    List<TopicOfInterest> temas;

    @Test
    public void pruebaMap(){

        Network network = new Network(new NetworkMap());

        network.addUser("Lucas");
        network.addUser("Ruben");
        network.addUser("David");

        network.addTopicOfInterest("Lucas", "Futbol");
        network.addTopicOfInterest("Lucas", "Baloncesto");
        network.addTopicOfInterest("Lucas", "Criquet");
        network.addTopicOfInterest("David", "Baloncesto");
        network.addTopicOfInterest("David", "Criquet");
        network.addTopicOfInterest("David", "Golf");
        network.addTopicOfInterest("Ruben", "Quidich");
        network.addTopicOfInterest("Ruben", "Criquet");

        temas = network.getTopics("Lucas");
        assertFalse(temas.contains(new TopicOfInterest("Tenis")));
        network.addTopicOfInterest("Lucas", "Padel");
        temas = network.getTopics("Lucas");
        assertTrue(temas.contains(new TopicOfInterest("Padel")));

        temas = network.getTopics("David");
        assertFalse(temas.contains(new TopicOfInterest("Rugby")));
        network.addTopicOfInterest("David", "Ping pong");
        temas = network.getTopics("David");
        assertTrue(temas.contains(new TopicOfInterest("Ping pong")));

        network.removeUser("Lucas");
        network.removeTopicOfInterest("Ruben", "Criquet");

        usuarios.add("David");
        assertEquals(usuarios, network.getUsersTopics("Baloncesto"));

        temas.clear();
        temas.add(new TopicOfInterest("Rugby"));
        temas.add(new TopicOfInterest("Ping pong"));
        temas.add(new TopicOfInterest("Bailar"));
        assertEquals(temas, network.searchTopics("Lucas", "David"));
    }

    @Test
    public void pruebaMatriz(){

        Network network = new Network(new NetworkMatriz());

        network.addUser("Lucas");
        network.addUser("Ruben");
        network.addUser("David");

        network.addTopicOfInterest("Lucas", "Futbol");
        network.addTopicOfInterest("Lucas", "Baloncesto");
        network.addTopicOfInterest("Lucas", "Criquet");
        network.addTopicOfInterest("David", "Baloncesto");
        network.addTopicOfInterest("David", "Criquet");
        network.addTopicOfInterest("David", "Golf");
        network.addTopicOfInterest("Ruben", "Quidich");
        network.addTopicOfInterest("Ruben", "Criquet");

        temas = network.getTopics("Lucas");
        assertFalse(temas.contains(new TopicOfInterest("Tenis")));
        network.addTopicOfInterest("Lucas", "Padel");
        temas = network.getTopics("Lucas");
        assertTrue(temas.contains(new TopicOfInterest("Padel")));

        network.removeUser("Lucas");

        usuarios.add("David");
        assertEquals(usuarios, network.getUsersTopics("Baloncesto"));

        temas.clear();
        temas.add(new TopicOfInterest("Ping pong"));
        temas.add(new TopicOfInterest("Tocar guitarra"));
        temas.add(new TopicOfInterest("Rugby"));
        temas.add(new TopicOfInterest("Bailar"));

        assertEquals(temas, network.searchTopics("Lucas", "Ruben"));
    }
}