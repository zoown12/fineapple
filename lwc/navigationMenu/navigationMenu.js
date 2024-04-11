// navigationMenu.js
import { LightningElement, track } from 'lwc';

export default class NavigationMenu extends LightningElement {
    @track selectedItem;
    @track showVocSearch = false;
    @track showNameVocSearch = false;
    @track showproductSearch = false;
    @track showvoctypeSearch = false;
    @track showvocMonthSearch = false;

    handleSelect(event) {
        this.selectedItem = event.detail.name;
        if (this.selectedItem === 'vocSearch') {
            this.showVocSearch = true;
            this.showNameVocSearch = false;
            this.showproductSearch = false;
            this.showvoctypeSearch = false;
            this.showvocMonthSearch = false;

        } else if (this.selectedItem === 'vocNameSearch') {
            this.showVocSearch = false;
            this.showNameVocSearch = true;
            this.showproductSearch = false;
            this.showvoctypeSearch = false;
            this.showvocMonthSearch = false;

        }else if(this.selectedItem === 'productSearch'){
            this.showVocSearch = false;
            this.showNameVocSearch = false;
            this.showproductSearch = true;
            this.showvoctypeSearch = false;
            this.showvocMonthSearch = false;
            
        }else if(this.selectedItem === 'vocTypeSearch'){
            this.showVocSearch = false;
            this.showNameVocSearch = false;
            this.showproductSearch = false;
            this.showvoctypeSearch = true;
            this.showvocMonthSearch = false;

        }else if(this.selectedItem === 'vocMonthSearch'){
            this.showVocSearch = false;
            this.showNameVocSearch = false;
            this.showproductSearch = false;
            this.showvoctypeSearch = false;
            this.showvocMonthSearch = true;
        }
         else {
            this.showproductSearch = false;
            this.showVocSearch = false;
            this.showNameVocSearch = false;
            this.showvoctypeSearch = false;
            this.showvocMonthSearch = false;
        }

        if (this.selectedItem === 'home') {
            const navigation = this.template.querySelector('lightning-vertical-navigation');
            navigation.selectedItem = null;
        }
    }  
}