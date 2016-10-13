import com.jcraft.jsch.*;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

public class IplanetAlerts {
	
	  public static void main(String[] arg) {
		String[] res = null;
		  
	    try{
	      JSch jsch=new JSch();  
	 
	      String host=null;
	      if(arg.length>0){
	        host=arg[0];
	      }
	      else{
	        host="webtools@drh00036.ute.fedex.com"; // enter username and ipaddress for machine you need to connect
	      }
	      String user=host.substring(0, host.indexOf('@'));
	      host=host.substring(host.indexOf('@')+1);
	 
	      Session session=jsch.getSession(user, host, 22);
	     
	      // username and password will be given via UserInfo interface.
	      UserInfo ui=new MyUserInfo();
	      session.setUserInfo(ui);
	      session.connect();
	 
	      String command=  "java TestSSH"; // enter any command you need to execute
	 
	      Channel channel=session.openChannel("exec");
	      ((ChannelExec)channel).setCommand(command);
	 
	      
	      channel.setInputStream(null);
	 
	      ((ChannelExec)channel).setErrStream(System.err);
	 
	      InputStream in=channel.getInputStream();
	      channel.connect();
	 
	      String data = null, line;
	      int i = 0;
	      int j = 0;
	      int k = 0;
		  String a[]=new String[13];
	      String b[]=new String[13];
	      String partition[] = new String[13];
	      String diskPart[] = new String[13];
	      BufferedReader br = new BufferedReader(new InputStreamReader(in));
	      while ((line = br.readLine()) != null) {
				System.out.println(line);
				// this is where the output of the code is coming add code here to insert command into SQL
				final String DB_URL = "jdbc:mysql://172.31.49.151/pdb60166?autoReconnect=true&useSSL=false";

				// Database credentials
				final String USER = "pinuser"; // enter correct username and password
				final String PASS = "pin@123";

				Connection conn = null;
				try {
					// STEP 2: Register JDBC driver
					Class.forName("com.mysql.jdbc.Driver");

					// STEP 3: Open a connection
					//System.out.println("Connecting to database...");
					conn = DriverManager.getConnection(DB_URL, USER, PASS);
				if(i%13==0){
					data = line.replaceAll("[Load Average:]", "");
				}
				else{
					if(i<13){
						String tmp,part_num1;
						part_num1 = "part"+i;
						tmp = "[part"+String.valueOf(i)+" used%:]";
						a[i-1] = line.replaceAll(tmp,"");
						double val = Double.parseDouble(a[i-1]);
						PreparedStatement prepStmt1 = conn.prepareStatement("UPDATE iplanet_alert SET part_number="+part_num1+",space_used="+val+" where server_name='prh00939'");
			  			prepStmt1.executeUpdate();
						// if(val>60.0){
						// 	System.out.println(val+"see if this prints");
						// 	partition[j] = "part"+i;
						// 	c[j]= Double.toString(val);
						// 	System.out.println("partition is"+partition[j]);
						// 	System.out.println("value at"+j+"is"+c[j]);
						// 	j++;
						// }
					}
					else{
						System.out.println("came to last else");
						String tmp,part_num2;
						part_num2 = "part"+i-13;
						tmp = "[part"+String.valueOf(i-13)+" used%:]";
						b[i-14] = line.replaceAll(tmp,"");
						double value = Double.parseDouble(b[i-14]);
						PreparedStatement prepStmt2 = conn.prepareStatement("UPDATE iplanet_alert SET part_number="+part_num2+",space_used="+value+" where server_name='prh00940'");
			  			prepStmt2.executeUpdate();						
						// if(value>60.0){
						// 	System.out.println(value+"see if this prints");
						// 	diskPart[k] = "part"+i;
						// 	d[k]= Double.toString(value);
						// 	System.out.println("partition is"+diskPart[k]);
						// 	System.out.println("value is"+d[k]);
						// 	k++;
						// }
					}
				}
				
        		//res = data.split("\\s+");
        		i = i +1;
				//final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
				// final String DB_URL = "jdbc:mysql://172.31.49.151/pdb60166?autoReconnect=true&useSSL=false";

				// // Database credentials
				// final String USER = "pinuser"; // enter correct username and password
				// final String PASS = "pin@123";

				// Connection conn = null;
				//Statement stmt = null;
				// try {
				// 	// STEP 2: Register JDBC driver
				// 	Class.forName("com.mysql.jdbc.Driver");

				// 	// STEP 3: Open a connection
				// 	//System.out.println("Connecting to database...");
				// 	conn = DriverManager.getConnection(DB_URL, USER, PASS);

					// STEP 4: Execute a query
					//System.out.println("Creating statement...");
				
			  		// .. Correct SQL statement .. //
					//PreparedStatement prepStmt = null;
			  		// if(i == 13){
			  			
			  		// 	PreparedStatement prepStmt = conn.prepareStatement("UPDATE iplanet_alert SET part_number="+partition[j]+",space_used="+c[j]+" where server_name='prh00939'");
			  		// 	prepStmt.executeUpdate();
			    //     }
			    //     else {
			    //     	if(i==26){
			    //     	//PreparedStatement prepStmt2 = conn.prepareStatement("UPDATE iplanet_cpu SET cpu_load="+data+" where server='prh00940'");
		
			  		// 	PreparedStatement prepStmt1 = conn.prepareStatement("UPDATE iplanet_details SET part_number="+diskPart[k]+",space_used="+d[k]+" where server_name='prh00940'");
       //                  prepStmt1.executeUpdate();
			    //     	}
			    // 	}
					 
					 conn.close();
				} catch (SQLException se) {
					// Handle errors for JDBC
					se.printStackTrace();
				return;
				} catch (Exception e) {
					// Handle errors for Class.forName
					e.printStackTrace();
					return;
				} finally {
					try {
						if (conn != null)
							conn.close();
					} catch (SQLException se) {
						se.printStackTrace();
					}
				}
			}
	      channel.disconnect();
	      session.disconnect();
	    }
	    catch(Exception e){
	      System.out.println(e);
	    }
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
	  }