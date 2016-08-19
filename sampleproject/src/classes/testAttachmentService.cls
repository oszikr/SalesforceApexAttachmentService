@IsTest
private class testAttachmentService {
	
    @IsTest(SeeAllData=false) 
    static void test(){
    	Case c1 = new Case(Subject = 'AttachmentTest');
    	insert c1;
    	
    	Attachment att = new Attachment(
    		Name = 'test.txt',
    		Body = blob.valueof('Testfile'),
    		parentId = c1.id
    	);
    	insert att;
    	
    	AttachmentService service = new AttachmentService();

		String req, res;

		req = '{"id":"'+ att.id +'", "user":"document_downloader", "pwd":""}';
    	res = AttachmentService.action(req);
    	
    	req = '{"id":"'+ att.id +'", "user":"document_downloader", "pwd":"WRONG"}';
    	res = AttachmentService.action(req);
    	
    	req = '{"id":"'+ 'DOESNOTEXISTS' +'", "user":"document_downloader", "pwd":""}';
    	res = AttachmentService.action(req);

    }
}