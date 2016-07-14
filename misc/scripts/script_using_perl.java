import com.jcraft.jsch.*;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
 
public class DReport extends EmailDomain {
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
          //System.out.println(new String(tmp, 0, i));
          String res = new String(tmp, 0, i);
          data = new String[4];
  		data = res.split("\\s+"); /* data is array of values */
  		String D1 = data[0];

  		System.out.println("D1"+ D1 );
  		String D2 = data[1];
  		System.out.println("D2"+ D2 );
  		String D3 = data[2];
  		System.out.println("D3"+ D3 );
  		String D4 = data[3];
  		System.out.println("D4"+ D4 );
  		String D5 = data[4];
  		System.out.println("D5"+ D5 );
  		String D6 = data[5];
  		System.out.println("D6"+ D6 );
  				
          //System.out.println("result"+res);
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
    	System.out.println("Insertion to table email_domains is successful.");
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
			//stmt = conn.createStatement();
			//String sql;
			//sql = "SELECT * FROM email_domains";
			//ResultSet rs = stmt.executeQuery(sql);
			UPDATE table-name 
   SET column-name = value, column-name = value, ...
			
			String sql = "UPDATE email_domains SET value=data[0] where server=TAO";
			PreparedStatement preparedStatement = conn.prepareStatement(sql);
			preparedStatement.executeUpdate(); 
      String sql = "UPDATE email_domains SET value=data[1] where server=Exchange";
      PreparedStatement preparedStatement = conn.prepareStatement(sql);
      preparedStatement.executeUpdate();
      String sql = "UPDATE email_domains SET value=data[2] where server=OCMS";
      PreparedStatement preparedStatement = conn.prepareStatement(sql);
      preparedStatement.executeUpdate();
      String sql = "UPDATE email_domains SET value=data[3] where server=Lotus";
      PreparedStatement preparedStatement = conn.prepareStatement(sql);
      preparedStatement.executeUpdate();
      String sql = "UPDATE email_domains SET value=data[4] where server=Other";
      PreparedStatement preparedStatement = conn.prepareStatement(sql);
      preparedStatement.executeUpdate();
      String sql = "UPDATE email_domains SET value=data[5] where server=Total";
      PreparedStatement preparedStatement = conn.prepareStatement(sql);
      preparedStatement.executeUpdate();                             			
			/*while (rs.next()) {
				// Retrieve by column name
				
				String domainType = rs.getString("domain_type");
				String domainMappinCount = rs.getString("domain_mapping_count");
			}

			// STEP 6: Clean-up environment
			rs.close(); */
			//stmt.close();
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