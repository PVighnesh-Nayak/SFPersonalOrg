import { LightningElement ,api} from 'lwc';

export default class PdfFormatComponent extends LightningElement {
    @api
    myRecordId;

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        console.log('upload',uploadedFiles );
        alert("No. of files uploaded : " + uploadedFiles.length);
    }
}