package e3;

import java.util.ArrayList;
import java.util.List;

public class NetworkMatriz implements NetworkManager{

    public List<String> userList = new ArrayList<>();
    public List<TopicOfInterest> topicOfInterestList = new ArrayList<>();
    private final int[][] matriz = new int[50][50];

    public void addUser(String user, List<TopicOfInterest> topicsOfInterest){
        userList.add(user);
    }

    public void removeUser(String user){
        int i = userList.indexOf(user);
        int j, w;

        userList.remove(user);
        for(j = i ; j < userList.size() ; j++){
            for (w= 0; w<topicOfInterestList.size();w++){
                matriz[j][w]=matriz[j+1][w];
            }
        }
    }

    public void addInterest(String user, TopicOfInterest topicOfInterest){
        if(!topicOfInterestList.contains(topicOfInterest)){
            topicOfInterestList.add(topicOfInterest);
        }
        matriz[userList.indexOf(user)][topicOfInterestList.indexOf(topicOfInterest)]=1;
    }
    public void removeInterest(String user, TopicOfInterest topicOfInterest){
        matriz[userList.indexOf(user)][topicOfInterestList.indexOf(topicOfInterest)] = 0;
    }

    public List<String> getUsers(){
        return userList;
    }

    public List<TopicOfInterest> getInterestsUser(String user){
        int i;
        List<TopicOfInterest> aux = new ArrayList<>();

        for(i = 0; i <topicOfInterestList.size();i++){
            if(matriz[userList.indexOf(user)][i] != 0){
                aux.add(topicOfInterestList.get(i));
            }
        }
        return aux;
    }

    public List<TopicOfInterest> getInterests(){
        return topicOfInterestList;
    }
}