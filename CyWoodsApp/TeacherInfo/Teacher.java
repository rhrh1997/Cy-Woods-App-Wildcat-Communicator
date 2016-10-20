import java.util.*;
import java.io.*;
import java.util.regex.*;

public class Teacher{
    public String name;
    public String department;
    public String website;
    public String email;
    public String photoURL;
    public String subject;
    public String description;
    public ArrayList<String[]> links;
    public ArrayList<String[]> folders;
    public Teacher(String website, String name){
        this.name = name;
        this.website = website;
        fetch(website);
    }
    
    public HashMap<String, Object> toMap(){
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("name", name);
        map.put("department", department);
        map.put("subject", subject);
        if( !website.equals("undefined"))
            map.put("website", website);
        if( email != null)
            map.put("email", email);
        if( photoURL != null)
            map.put("photo", photoURL);
        if( description != null)
            map.put("description", description);
        if( links != null){
            ArrayList<List<String>> tmp = new ArrayList<List<String>>();
            for(String[] sr : links)tmp.add(Arrays.asList(sr));
            map.put("links", tmp);
        }
        if( folders != null){
            ArrayList<List<String>> tmp = new ArrayList<List<String>>();
            for(String[] sr : folders)tmp.add(Arrays.asList(sr));
            map.put("folders", tmp);
        }
        return map;
    }
    
    private static final Pattern PPHOTO = Pattern.compile("<img src=\"([^\"]+?)\" id=\"ctl00_cphMain_imgUserPic\" .+? class=\"imgBorder\" alt=\"User");
    private static final Pattern PDESC = Pattern.compile("ctl00_cphMain_divWelcomeNotes.+?<div>(.+?)</div>\\s+</td>");
    private static final Pattern PURL = Pattern.compile("<a id=\"ctl00_rptQuickLinks[^\"]+?\" href=\"(http://[^\"]+?)\" .+?/>&nbsp;([^<]+?)</a>");
    private static final Pattern FURL = Pattern.compile("id='lnkFolder_\\d+' popupPath=\"(http://[^\"]+?)\" .+?/> (.+?)</a>");
    
    public ArrayList<String[]> match(String html, Pattern p, int g){
        ArrayList<String[]> list = new ArrayList<String[]>();
        Matcher m = p.matcher(html);
        while(m.find()){
            String[] sr = new String[g];
            for(int i = 0; i<g; i++)
                sr[i] = m.group(i+1);
            list.add(sr);
        }
        return list;
    }
    
    public void fetch(String w){
        if( w.equals("undefined") || !w.startsWith("http://www.epsilen.com")) return;
        String html = new Fetcher(website).fetch().replace("\n"," ");
        ArrayList<String[]> purl = match(html, PPHOTO, 1);
        if( !purl.isEmpty() ){
            photoURL = purl.get(0)[0];
            if( photoURL.equals("Images/noMembersBig.jpg"))
                photoURL = "http://www.epsilen.com/"+photoURL;
        }
        ArrayList<String[]> desc = match(html, PDESC, 1);
        if( !desc.isEmpty() ){
            description = desc.get(0)[0].trim();
            description = description.replace("</div>", "\n");
            description = description.replaceAll("<.+?>", "");
            description = description.replaceAll("&.{3,6};", " ");
            description = description.replaceAll(" +", " ");
            if( description.contains("There are no welcome notes to display."))
                description = null;
            //System.out.println(description);
            //System.out.println(description);
        }
        ArrayList<String[]> links = match(html, PURL, 2);
        if( !links.isEmpty()){
            this.links = new ArrayList<String[]>();
            for(String[] sr : links){
                //System.out.println(Arrays.toString(sr));
                this.links.add(sr);
            }
        }
        ArrayList<String[]> folders = match(html, FURL, 2);
        if( !folders.isEmpty()){
            this.folders = new ArrayList<String[]>();
            for(String[] sr : folders){
                //System.out.println(Arrays.toString(sr));
                this.folders.add(sr);
            }
        }
    }
}