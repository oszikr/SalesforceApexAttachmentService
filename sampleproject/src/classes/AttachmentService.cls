@RestResource(urlMapping='/AttachmentService') 
global without sharing class AttachmentService {
	
	public static transient Attachment att;
	
	public class AttachmentServiceException extends Exception{}
	
	@HttpPost 
	global static void doPost() {
		RestContext.response.responseBody = Blob.valueOf(action(RestContext.request.requestBody.toString()));
	}
	
	@HttpGet 
	global static void doGet() {
		RestContext.response.responseBody = Blob.valueOf(action(RestContext.request.requestBody.toString()));
	}
	
	private static String pwdCheck = ''; // passwd
	private static String userCheck = 'document_downloader'; // username
	
	public static String action(String requestBody){
		system.debug('AttachmentService> ' + requestBody);
		string response;
		try{
			AttachmentRequest aReq = (AttachmentRequest)JSON.deserialize(requestBody, AttachmentRequest.class);
			if(aReq.user == userCheck && aReq.pwd == pwdCheck){
				att = [SELECT Id, Name, Body FROM Attachment WHERE Id = :aReq.id];
				AttachmentWrapper aWrapper = new AttachmentWrapper(att);
				att = null;
				response = JSON.serialize(aWrapper);
			}
			else{
				throw new AttachmentServiceException('Wrong username or password.');
			}
		}
		catch(Exception ex){
			AttachmentWrapper aWrapper = new AttachmentWrapper();
			aWrapper.hasError = true;
			aWrapper.errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString();
			response = JSON.serialize(aWrapper);
		}
		system.debug('AttachmentService> ' + response);
		return response;
	}
	
	public class AttachmentRequest{
		public String id; // attachment id
		public String user; // usarname
		public String pwd; // passwd
	}
	
	public class AttachmentWrapper {
		public String name;
		public String id;
		public String body;
		public boolean hasError;
		public String errorMessage;
		
		public AttachmentWrapper(){
			this.hasError = false;
		}
		
		public AttachmentWrapper(Attachment attp){
			this.Name = attp.Name;
			this.Id = String.valueof(attp.Id);
			this.Body = EncodingUtil.base64Encode(attp.Body);
			this.hasError = false;
		}	
	}
	
}
