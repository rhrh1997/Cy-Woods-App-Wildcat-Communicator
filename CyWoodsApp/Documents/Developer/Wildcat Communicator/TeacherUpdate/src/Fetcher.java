import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.SocketAddress;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;
import java.io.*;

public class Fetcher {
	private String URL;
	private StringBuffer post = new StringBuffer();
	private StringBuffer cookie = new StringBuffer();
	private String html;
	private boolean followRedir = true;
	private List<String> cookies;
    public static boolean CACHE = false;
	
	public Fetcher(String u){
		setURL(u);
	}
	
	public void addPost(String k, String v){
		post.append((post.length()==0?"":"&") + k+"="+enc(v));
	}
	
	public void addCookie(String k, String v){
		addCookie(k+"="+v);
	}
	public void addCookie(String s){
		cookie.append((cookie.length()==0?"":";") + s);
	}
	private static final int TRIES = 4;
	private static final int TIMEOUT = 30*1000;
	
	public String fetch(){
		for(int abc = 0; abc<TRIES; abc++)
		{
			HttpURLConnection con = null;
			try{
                if( CACHE && hasCache())
                    return getCache();
				con = (HttpURLConnection)new URL(URL).openConnection();
		        con.setReadTimeout(TIMEOUT);
		        con.setUseCaches(false);
		        con.setInstanceFollowRedirects(isFollowRedir());
		        boolean POST = post.length()!=0;
			    if(POST){
			        con.setDoOutput(true);
			        con.setRequestProperty("Content-Length", ""+post.length());
			        con.setRequestMethod("POST");
		        }
			    if( cookie.length()!= 0)
			        con.setRequestProperty("Cookie", cookie.toString());
			    con.connect();
			    if( POST){
			    	OutputStream out = con.getOutputStream();
			    	out.write(post.toString().getBytes());
			    	out.flush();
			    	//System.out.println(post);
			    }
			    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			    String line;
			    StringBuffer data = new StringBuffer();
			    while ((line = in.readLine()) != null)
			    	data.append(line+"\n");
			    setHtml(data.toString());
			    //System.out.println(con.getHeaderFields());
			    List<String> cookies = null;
			    if((cookies=con.getHeaderFields().get("set-cookie")) == null)
			    	cookies = con.getHeaderFields().get("Set-Cookie");
			    setCookies(cookies);
                cache();
			    return getHtml();
			}catch(Exception e){
				e.printStackTrace();
				/*con != null){
					BufferedReader in = new BufferedReader(new InputStreamReader(con.getErrorStream()));
				    String line;
				    try {
						while ((line = in.readLine()) != null)
							System.out.println(line);
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}*/
			}
		}
		return null;
	}
    
    public static File file(String f){
        File cdir = new File("cache");
        if( !cdir.exists())
            cdir.mkdir();
        return new File(cdir, f);
    }
    
    public static String hash(String s){
        return Integer.toHexString(s.hashCode());
    }
    
    public boolean hasCache(){
        return file(hash(URL)).exists();
    }
    
    public String getCache() throws IOException{
        StringBuffer sb = new StringBuffer();
        Scanner file = new Scanner(file(hash(URL)));
        while(file.hasNextLine()){
            sb.append(file.nextLine());
            sb.append("\n");
        }
        return sb.toString();
    }
    
    public void cache() throws IOException{
        PrintWriter out = new PrintWriter(file(hash(URL)));
        out.println(getHtml());
        out.close();
    }
	
	public static String enc(String s){
		try {
			return URLEncoder.encode(s, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			return s;
		}
	}

	public String getURL() {
		return URL;
	}

	public void setURL(String uRL) {
		URL = uRL;
	}

	public String getHtml() {
		return html;
	}

	private void setHtml(String html) {
		this.html = html;
	}

	public List<String> getCookies() {
		return cookies;
	}

	private void setCookies(List<String> cookies) {
		this.cookies = cookies;
	}
	
	public static void main(String[] args){
	}

	public boolean isFollowRedir() {
		return followRedir;
	}

	public void setFollowRedir(boolean followRedir) {
		this.followRedir = followRedir;
	}
	
	
}
