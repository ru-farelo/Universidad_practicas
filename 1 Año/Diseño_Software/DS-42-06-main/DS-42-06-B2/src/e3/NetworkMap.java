package e3;

import java.util.*;

public class NetworkMap implements NetworkManager{

    private final ArrayList<TopicOfInterest> list = new ArrayList<>();
    private final Map<String, ArrayList<TopicOfInterest>> listMap = new LinkedHashMap<>();

    public void addUser(String user, List<TopicOfInterest> topicOfInterest){

        listMap.put(user, (ArrayList<TopicOfInterest>) topicOfInterest);
    }
    public void removeUser(String user){
        listMap.remove(user);
    }

    public void addInterest(String user, TopicOfInterest topicOfInterest){
        ArrayList<TopicOfInterest> topicList =listMap.get(user);

        if (!topicList.contains(topicOfInterest)){
            topicList.add(topicOfInterest);
        }
        if(!list.contains(topicOfInterest)){
            list.add(topicOfInterest);
        }
    }

    public void removeInterest(String user, TopicOfInterest topicOfInterest){
        list.remove(topicOfInterest);
    }

    public List<TopicOfInterest> getInterests(){
        return list;
    }

    public List<TopicOfInterest> getInterestsUser(String user) {
        return listMap.get(user);
    }

    public List<String> getUsers(){//*****
        return new ArrayList<>(listMap.keySet());
    }
}