import { LightningElement ,wire, track } from 'lwc';
// import the data from the apex method 
import LoadAllItem from '@salesforce/apex/ProgramItemSummaryReport.LoadAllItem'



export default class DfvProgramOrderItemSummaryReportComponent extends LightningElement {
// to bind the property to the html 
    @track hrefdata;
   
    // to get all the pos item details and store it in a variable
    @wire(LoadAllItem)
    programOrderSummaryReport;
    
    //  To download the report using csv 
    exportToCSV() 
    {  
        // to add the column header
        // element.style.backgroundColor = red;
        let columnHeader = ["BRAND NAME","ITEM NUMBER","ITEM NAME","ITEM TYPE NAME","PACK OF","PRICE ","TOTAL QUANTITY","TOTAL QUANTITY IN EACHES ","TOTAL LINE AMOUNT","VENDOR"]; 
      
        //  get the data to the row and store it in the variable
        let columnDataFields = ["BrandName__c","ItemNo__c","PosItemName__c","ItemType__c","PosPackOf__c","PosItemPrice__c","Total_Qty_Ordered__c","Total_Pieces_Ordered__c","Total_Amount__c","Vendor__c"]; // This array holds the keys in the json data  
         
        // to store all the pos items in an variable
        var programItemList = this.programOrderSummaryReport.data;  
        let csvIterativeData;  
        let csvSeperator  
        let newLineCharacter;  
        let programTotalAmount = 0;
        let programTotalQty = 0;
        let programTotalPiecesOrdered = 0;

        // createing a new variable 'BrandItemSet' to hold the unique brand name
        let BrandItemSet = new Set();
        csvSeperator = ",";  
        newLineCharacter = "\n";  
        csvIterativeData = "";  
        
        csvIterativeData += columnHeader.join(csvSeperator); 
        csvIterativeData += newLineCharacter; 

        // loop to calculate the total amount,total ordered quantity and total pieces ordered for the program
        for(var i=0;i< programItemList.length;i++ )
        {
          programTotalAmount += programItemList[i].Total_Amount__c;
          programTotalQty += programItemList[i].Total_Qty_Ordered__c;
          programTotalPiecesOrdered += programItemList[i].Total_Pieces_Ordered__c;
          BrandItemSet.add(programItemList[i].BrandName__c);
        }
        // add the row for the total amount,total ordered quantity and total pieces ordered of all the brands
        let columnTotalCount = ["PROGRAM TOTAL","","","","","",programTotalQty,programTotalPiecesOrdered,"$"+programTotalAmount]

        // to hold the array of brands
        let BrandItemListArray =[];

        // from the 'BrandItemSet' we are getting each brand and giving to an array.
        BrandItemSet.forEach(function(value, valueAgain, set) 
        {
          BrandItemListArray.push(value);
          BrandItemListArray.sort();
        });
      
        // for each brand get the item details for the brand and create a rows in the csv sheet
        for(let brand = 0; brand < BrandItemListArray.length; brand++)
        {
          csvIterativeData += newLineCharacter;  
          let BrandData = [];
          let BrandTotalAmount = 0;
          let BrandTotalPiecesOrdered = 0;
          let BrandTotalQty = 0;
           
         // for a brand get each pos items and compare if the same brand name matches add the particular item to brand data array
         for (let i = 0; i < programItemList.length; i++)
         {
            if(programItemList[i].BrandName__c == BrandItemListArray[brand])
            {
              BrandData.push(programItemList[i])
            }
         }

        // Calculate the total amount,total ordered quantity and total pieces ordered for the particular brand items
          for(let j = 0; j < BrandData.length; j++)
          {
        
            BrandTotalAmount += BrandData[j].Total_Amount__c;
            BrandTotalPiecesOrdered += BrandData[j].Total_Pieces_Ordered__c;
            BrandTotalQty += BrandData[j].Total_Qty_Ordered__c;
            
          }
          // add the row to get the total amount,total ordered quantity and total pieces ordered for the particular brand items
          let columnData=[BrandItemListArray[brand] + " TOTAL","","","","","",BrandTotalQty,BrandTotalPiecesOrdered,"$"+BrandTotalAmount];
      

          // for each brand pos item we are creating the row in excel sheet
        for (let i = 0; i < BrandData.length; i++) 
        { 
     
          let counter = 0;  

          for (let iteratorObj in columnDataFields) 
          {  
        
            // data key is the variiable who will hold all the pos item data
              let dataKey = columnDataFields[iteratorObj];  
              let fieldName ="";
              fieldName = dataKey;
          // if the datakey has data in it then move the data to the 'csvIterativeData' variable
        
              if (counter > 0) 
              {
                csvIterativeData += csvSeperator;
              }

              // if the brand data is not null and undifined
              if (  BrandData[i][dataKey] !== null &&  BrandData[i][dataKey] !== undefined  )
              {
                // to add the '$' sign to the price and total amount
                  if( fieldName == "PosItemPrice__c" ||  fieldName == "Total_Amount__c" )
                  {
                    csvIterativeData += '"'+'$' + BrandData[i][dataKey] + '"'; 
                  }
                  else
                  {
                    // to merge the brand name
                    if(i != 0 && fieldName == "BrandName__c")
                    {
                      csvIterativeData += '"' +  '"';
                    }
                    else
                    {
                      csvIterativeData += '"' + BrandData[i][dataKey] + '"';

                    }
                   
                  }
              }
              else
              {  
                csvIterativeData += '""';  
              }     
              counter++;  
          }  

          csvIterativeData += newLineCharacter;  
        
        }  
        csvIterativeData += columnData;
        csvIterativeData += newLineCharacter;  
      }
      csvIterativeData += newLineCharacter;  

      csvIterativeData += columnTotalCount;
      // finally move all the data to the 'csvIterativeData' with the help of charset it is coverted to the csv format and savedin hrefdata
      this.hrefdata = "data:text/csv;charset=utf-8," + encodeURIComponent(csvIterativeData);
    }     
}