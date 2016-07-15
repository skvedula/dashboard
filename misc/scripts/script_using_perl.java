import com.jcraft.jsch.*;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
 
public class DReport  {
  public static void main(String[] arg) {
  String[] data = null;
    
    try{
      JSch jsch=new JSch();  
 
      String host=null;
      if(arg.length>0){
        host=arg[0];
      }
      else{
        host="webtools@qwb00046.ute.fedex.com"; // enter username and ipaddress for machine you need to connect
      }
      String user=host.substring(0, host.indexOf('@'));
      host=host.substring(host.indexOf('@')+1);
 
      Session session=jsch.getSession(user, host, 22);
     
      // username and password will be given via UserInfo interface.
      UserInfo ui=new MyUserInfo();
      session.setUserInfo(ui);
      session.connect();
 
      String command=  "/opt/fedex/web/reports/EmailDomainReport/emailstatus.pl"; // enter any command you need to execute
 
      Channel channel=session.openChannel("exec");
      ((ChannelExec)channel).setCommand(command);
 
      
      channel.setInputStream(null);
 
      ((ChannelExec)channel).setErrStream(System.err);
 
      InputStream in=channel.getInputStream();
      channel.connect();
 
      byte[] tmp=new byte[1024];
      while(true){
        while(in.available()>0){
          int i=in.read(tmp, 0, 1024);
          if(i<0)break;
          String res = new String(tmp, 0, i);
          data = new String[4];
      data = res.split("\\s+"); /* data is array of values */

        }
        
        if(channel.isClosed()){
          System.out.println("exit-status: "+channel.getExitStatus());
          break;
        }
        try{Thread.sleep(1000);}catch(Exception ee){}
      }
      
      channel.disconnect();
      session.disconnect();
    }
    catch(Exception e){
      System.out.println(e);
    }
    //Call DB
    String response = insertToEmailDomains(data);
    
    if(response.equalsIgnoreCase("success")){
      System.out.println("Insertion to table email_domains is succesful.");
    }
    else
      System.out.println("Insertion failed.");
    
  }
 
  public static class MyUserInfo implements UserInfo{
    public String getPassword(){ return passwd; }
    public boolean promptYesNo(String str){
        str = "Yes";
        return true;}
   
    String passwd;
 
    public String getPassphrase(){ return null; }
    public boolean promptPassphrase(String message){ return true; }
    public boolean promptPassword(String message){
        passwd="root4Edt$"; // enter the password for the machine you want to connect.
        return true;
    }
    public void showMessage(String message){
    
    }
  
    }
  
  
  public static String insertToEmailDomains(String[] data){
    
    System.out.println("Before Connecting to database...");

    final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    final String DB_URL = "jdbc:mysql://172.31.49.151/pdb60166";
    

    // Database credentials
    final String USER = "pinuser";
    final String PASS = "pin@123";

    Connection conn = null;
    //Statement stmt = null;
    try {
      // STEP 2: Register JDBC driver
      Class.forName("com.mysql.jdbc.Driver");

      // STEP 3: Open a connection
      System.out.println("Connecting to database...");
      conn = DriverManager.getConnection(DB_URL, USER, PASS);

      // STEP 4: Execute a query
      System.out.println("Creating statement...");
      //int data1 = Integer.parseInt(data[0]);
      String data1 = data[0];
        String d1 = data1.replaceAll("[,]", "");
        int D1 = Integer.parseInt(d1);
          // System.out.println("tao: "+ D1 );  
          
          String data2 = data[1];
        String d2 = data2.replaceAll("[,]", "");
        int D2 = Integer.parseInt(d2);
        // System.out.println("exchange: "+ D2 );
        
        String data3 = data[2];
        String d3 = data3.replaceAll("[,]", "");
        int D3 = Integer.parseInt(d3);
        // System.out.println("ocms: "+ D3 );
        
        String data4 = data[3];
        String d4 = data4.replaceAll("[,]", "");
        int D4 = Integer.parseInt(d4);
        // System.out.println("lotus: "+ D4 );
        
        String data5 = data[4];
        String d5 = data5.replaceAll("[,]", "");
        int D5 = Integer.parseInt(d5);
        // System.out.println("other: "+ D5 );
        
        String data6 = data[5];
        String d6 = data6.replaceAll("[,]", "");
        int D6 = Integer.parseInt(d6);
        // System.out.println("total: "+ D6 );
        
          PreparedStatement prepStmt = conn.prepareStatement("UPDATE email_domains SET value="+D1+" where server='TAO'");
       prepStmt.executeUpdate();
       PreparedStatement prepStmt1 = conn.prepareStatement("UPDATE email_domains SET value="+D2+" where server='Exchange'");
       prepStmt1.executeUpdate();
       PreparedStatement prepStmt2 = conn.prepareStatement("UPDATE email_domains SET value="+D3+" where server='OCMS'");
       prepStmt2.executeUpdate();
       PreparedStatement prepStmt3 = conn.prepareStatement("UPDATE email_domains SET value="+D4+" where server='Lotus'");
       prepStmt3.executeUpdate();
       PreparedStatement prepStmt4 = conn.prepareStatement("UPDATE email_domains SET value="+D5+" where server='Other'");
       prepStmt4.executeUpdate();
       PreparedStatement prepStmt5 = conn.prepareStatement("UPDATE email_domains SET value="+D6+" where server='Total'");
       prepStmt5.executeUpdate();
       conn.close();

    } catch (SQLException se) {
      // Handle errors for JDBC
      se.printStackTrace();
      return "false";
    } catch (Exception e) {
      // Handle errors for Class.forName
      e.printStackTrace();
      return "false";
    } finally {
      /*try {
        if (stmt != null)
          stmt.close();
      } catch (SQLException se2) {
      } */
      try {
        if (conn != null)
          conn.close();
      } catch (SQLException se) {
        se.printStackTrace();
      }
    }
 
    
  return "Success";
  
  
  }
  
  }