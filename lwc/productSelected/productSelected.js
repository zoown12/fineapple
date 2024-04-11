import { LightningElement,api,wire } from 'lwc';
import getSelectedProducts from '@salesforce/apex/ProductController.getSelectedProducts';
import deleteProduct from '@salesforce/apex/ProductController.deleteProduct';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ProductSelected extends LightningElement {
    @api recordId;
    productLists;
    error;
    columns = [
        { label: '제품명', fieldName: 'name', type: 'text',hideDefaultActions: true  },
        { label: '가격', fieldName: 'price', type: 'currency', typeAttributes: { currencyCode: 'KRW' },hideDefaultActions: true  },
        { label: '수량', fieldName: 'totalRecords', type: 'number' ,hideDefaultActions: true },
        { label: '', type: 'button', typeAttributes: { label: '삭제', name: 'delete', variant: 'destructive', class: 'slds-button slds-button_icon' },
        cellAttributes: { 
            alignment: 'center' 
        } 
    }
    ];

    //고객이 선택한 제품 가져오기
    @wire(getSelectedProducts,{recordId :'$recordId'})
    wiredGetSelectedList({error,data}){
        if(data){
            this.error = undefined;
            this.productLists = data.map(list =>({
                ...list,
                name: list.Name,
                price: list.price,
                totalRecords: list.totalRecords
            }));
        }else if(error){
            this.productLists = undefined;
            this.error = error;
        }
    }

    //삭제 클릭시 처리
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            default:
                break;
        }
    }

    //삭제 로직 실행
    deleteRow(row) {
        deleteProduct({ productId: row.Name, recordId: this.recordId })
            .then(() => {
                
                this.productLists = this.productLists.filter(item => item.Name !== row.Name);
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '제품 삭제 완료',
                        message: '선택한 제품을 삭제했습니다.',
                        variant: 'success'
                    })
                );
                setTimeout(() => {
                    window.location.reload();
                }, 600);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '제품 삭제 불가',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}