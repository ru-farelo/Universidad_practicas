package e3;

import java.util.ArrayList;
import java.util.List;

public class Network{

    NetworkManager map;
    public List<String> userList = new ArrayList<>();
    public List<TopicOfInterest> topicList = new ArrayList<>();

    Network(NetworkManager networkManager){
        this.map = networkManager;
    }

    public void addUser(String user){
        List<TopicOfInterest> topicOfInterest = new ArrayList<>();
        map.addUser(user, topicOfInterest);
        userList.add(user);
    }
    public void removeUser(String user){
        map.removeUser(user);
    }

    public void addTopicOfInterest(String user, String topicOfInterest){
        TopicOfInterest topic = new TopicOfInterest(topicOfInterest);
        map.addInterest(user,topic);
        topicList.add(topic);
    }
    public void removeTopicOfInterest(String user, String topicOfInterest){
        TopicOfInterest topic = new TopicOfInterest(topicOfInterest);
        map.removeInterest(user,topic);
    }

    public List<TopicOfInterest> getTopics(String user){
        return map.getInterests();
    }

    public List<String> getUsersTopics(String topicOfInterest){

        int i;
        List<String> userInteresting = new ArrayList<>();
        TopicOfInterest tema =new TopicOfInterest(topicOfInterest);
        List<String> usersList = map.getUsers();
        List<TopicOfInterest> topicList;

        for(i = 0; i < usersList.size(); i++){
            topicList=map.getInterestsUser(usersList.get(i));
            if(topicList.contains(tema)){
                userInteresting.add(usersList.get(i));
            }
        }
        return userInteresting;
    }

    public List<TopicOfInterest> searchTopics(String user1, String user2){
        int i = 0;
        List<TopicOfInterest> temasComun = new ArrayList<>();
        List<TopicOfInterest> temasUser1 = getTopics(user1);
        List<TopicOfInterest> temasUser2 = getTopics(user2);

        while (i < temasUser1.size()){
            if(temasUser2.contains(temasUser1.get(i))){
                temasComun.add(temasUser1.get(i));
            }
            i++;
        }
        return temasComun;
    }
}