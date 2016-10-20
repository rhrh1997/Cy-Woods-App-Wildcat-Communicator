import java.util.*;
import java.io.*;
import java.net.*;
import java.util.regex.*;
import org.json.simple.JSONValue;

public class TeacherInfo{
    public static void main(String[] args)throws Exception{
        
        Fetcher.CACHE = true;
        
        new TeacherInfo().run(args);
    }
    final String TURL = "https://app.cfisd.net/urlcap/campus_list_011.html";
    final String PAT = "a href=(http://www.epsilen.com/.+?)>(.+?)</a>.+?<a href=mailto:(.+?)>";
    final String PAT2 = "<span class='arhev'>([^<>]+?)<a href=mailto:(.+?)>";
    public void run(String[] args)throws Exception{
        boolean rematch = false;
        for(String s : args)
            if( s.equals("match") ){
                rematch = true;
            }
        //if( rematch ){
            System.out.println("matching");
            sanitize();
            match();
        //}
        
        Scanner sfile = new Scanner(new File("supplement.txt"));
        HashSet<String> supp = new HashSet<String>();
        
        while(sfile.hasNextLine())
            supp.add(sfile.nextLine().split(" = ")[0]);
        
        PrintWriter mout = new PrintWriter(new File("teachersmatch.txt"));
        
        Scanner file = new Scanner(new File("match.txt"));
        ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
        while(file.hasNextLine()){
            String[] s1 = file.nextLine().split(" : ");
            String[] s2 = s1[1].split(" = ");
            String[] s3 = s2[1].split("\\|");
            //System.out.println(Arrays.toString(s3) + " " +  supp.contains(s2[0]));
            Teacher t = null;
            if( supp.contains(s2[0])){
                t = new Teacher("undefined", s2[0]);
                t.description = "This teacher's information is currently unavailable. Please check back later!";
            }else{
                t = new Teacher(s3[4], s3[0]);
                t.email = s3[1];
            }
            t.department = s3[2];
            t.subject = s3[3];
            if( t.email != null)
            mout.println(t.name+"\n"+t.email);
            list.add(t.toMap());
        }
        mout.close();
        PrintWriter out = new PrintWriter(new File("teachers.json"));
        out.println(JSONValue.toJSONString(list));
        out.close();
    }
    
    public ArrayList<String[]> allList(){
        ArrayList<String[]> list = new ArrayList<String[]>();
        String html = new Fetcher(TURL).fetch();
        html = html.replace("\n","");
        html = html.replace("&nbsp;", "");
        Pattern p = Pattern.compile(PAT);
        Matcher m = p.matcher(html);
        while(m.find()){
            String eps = m.group(1);
            String name = m.group(2);
            String email = m.group(3);
            //System.out.println(name + " "+ email);
            list.add(new String[]{name, email, eps});
        }
        p = Pattern.compile(PAT2);
        m = p.matcher(html);
        while(m.find()){
            String name = m.group(1);
            String email = m.group(2);
            //System.out.println(name + " "+ email);
            list.add(new String[]{name, email});
        }
        return list;
    }
    
    
    public ArrayList<String[]> oldList() throws Exception{
        Scanner file = new Scanner(new File("teachers.txt"));
        ArrayList<String[]> list = new ArrayList<String[]>();
        while(file.hasNextLine()){
            String[] sr = file.nextLine().split("\\|");
            list.add(new String[]{sr[1], sr[2], sr[3]});
        }
        return list;
    }
    
    public void match() throws Exception{
        ArrayList<String[]> tlist = allList();
        //tlist.addAll(oldList());
        ArrayList<String[]> oldList = oldList();
        PrintWriter out = new PrintWriter(new File("match.txt"));
        Scanner file = new Scanner( new File("list-clean.txt"));
        ArrayList<Object[]> slist = new ArrayList<Object[]>();
        while(file.hasNextLine()){
            if( file.nextLine().trim().equals("DEP") ){
                String dep = file.nextLine();
                while(file.hasNextLine()){
                    String subj = file.nextLine();
                    if( subj.equals("END")) break;
                    while(file.hasNextLine()){
                        String s = file.nextLine();
                        if( s.isEmpty())
                            break;
                        //System.out.println(s);
                        //close("test", s);
                        String[] best = null;
                        double max = 0;
                        for(String[] sr : tlist){
                            double x = close(sr[0], s);
                            boolean good = sr.length > 2 && sr[2].startsWith("http://www.epsi");
                            if( x > max ){
                                max = x;
                                best = sr;
                            }
                        }
                        if( max < 0.8 ){
                            for(String[] sr : oldList){
                                double x = close(sr[0], s);
                                boolean good = sr.length > 2 && sr[2].startsWith("http://www.epsi");
                                if( x > max ){
                                    max = x;
                                    best = sr;
                                }
                            }
                        }
                        //System.out.println(s + " = " + best[0] + " " + max);
                        slist.add(new Object[]{best, max, s, dep, subj});
                    }
                }
            }
        }
        /*for( String[] s : oldList()){
            Object[] best = null;
            double max = 0;
            for(Object[] o : slist){
                double x = close(s[0], (String)o[2]);
                if( x > max ){
                    max = x;
                    best = o;
                }
            }
            if( max < 0.9)
            System.out.println(max + " : " + s[0] + " = " + best[2] );
        }*/
        Collections.sort(slist, new Comparator<Object[]>(){
            public int compare(Object[] o1, Object[] o2){
                return (Double)o1[1] < (Double)o2[1] ? 1 : -1;
            }
        });
        for(Object[] o : slist){
            String[] sr = (String[])o[0];
            out.println(o[1] + " : " + o[2] + " = " + sr[0] + "|"+sr[1] + "|"+o[3] + "|"+o[4] + "|"+ (sr.length<3?"undefined":sr[2]) );
        }
        out.close();
    }
    
    public double close(String key, String cand){
        key = key.replaceAll("[^a-zA-Z0-9 ]+", "");
        cand = cand.replaceAll("[^a-zA-Z0-9 ]", "");
        int max = lcs(key, cand);
        for(int i = 0; i<cand.length(); i++)
            if( cand.charAt(i) == ' '){
                //System.out.println(cand.substring(i+1, cand.length()) + " " + cand.substring(0,i));
                max = Math.max(max, lcs(key, cand.substring(i+1, cand.length()) + " " + cand.substring(0,i)));
            }
        return (double)max/key.length();
    }
    
    public int lcs(String s1, String s2){
        int[] p = new int[s2.length()+1];
        for(int i = 1; i<=s1.length(); i++){
            int[] c = new int[s2.length()+1];
            for(int j = 1; j<=s2.length(); j++){
                if( s1.charAt(i-1) == s2.charAt(j-1) )
                    c[j] = p[j-1]+1;
                else{
                    c[j] = Math.max(c[j-1], p[j]);
                }
            }
            p = c;
        }
        return p[s2.length()];
    }
    
    public void sanitize() throws Exception{
        PrintWriter out = new PrintWriter(new File("list-clean.txt"));
        Scanner file = new Scanner( new File("list.txt"));
        while(file.hasNextLine()){
            if( file.nextLine().trim().equals("DEP") ){
                out.println("DEP");
                String dep = file.nextLine();
                out.println(dep);
                while(file.hasNextLine()){
                    String s = file.nextLine();
                    s = s.replaceAll("\\(.+\\)", "");
                    s = s.replaceAll("\\s+", " ");
                    s = s.trim();
                    out.println(s);
                    if( s.equals("END"))break;
                }
            }
        }
        out.close();
    }
}