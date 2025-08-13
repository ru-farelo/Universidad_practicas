package es.udc.redes.webserver;
import java.util.Map;

public class YourServlet implements MiniServlet {


	public YourServlet(){

	}

        @Override
	public String doGet (Map<String, String> parameters){
		int first = Integer.parseInt(parameters.get("first"));
		int second = Integer.parseInt(parameters.get("second"));
		int sum = first + second;

		return printHeader() + printBody(sum) + printEnd();

	}

	private String printHeader() {
		return "<html><head> <title>Sum</title> </head> ";
	}

	private String printBody(int sum) {
		return "<body> <h1> Sum = " + sum + "</h1></body>";
	}

	private String printEnd() {
		return "</html>";
	}
}
