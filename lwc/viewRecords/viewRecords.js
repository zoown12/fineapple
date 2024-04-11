import { LightningElement, wire,api } from 'lwc';
import getStoreInfo from '@salesforce/apex/getStoreInfo.getStoreInfo';
import Id from "@salesforce/user/Id";

export default class ViewRecords extends LightningElement {
    userId = Id;
    store;
    now = new Date();
    get today(){
        return `${this.now.getFullYear()}. ${this.now.getMonth()+1}. ${this.now.getDate()}.`;
    }

    //해당 유저의 지점정보 가져오기
    @wire(getStoreInfo,{ownerId:'$userId'})
    storeInfo({ error, data }) { 
        if (data) {
            this.store = data; 
            this.error = undefined;
        } else if (error) {
            this.store = undefined;
            this.error = error;
        }
    }
    
    @api
    get name(){
        return this.store?.Name ?? '';
    }
    
}