package e3;

import java.util.Objects;

public class TopicOfInterest {
    String topicOfInterest;

    public TopicOfInterest(String temasInteres){
        this.topicOfInterest = temasInteres;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TopicOfInterest that = (TopicOfInterest) o;
        return Objects.equals(topicOfInterest, that.topicOfInterest);
    }
}