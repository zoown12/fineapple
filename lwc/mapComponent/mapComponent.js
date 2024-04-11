import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, getFieldDisplayValue } from 'lightning/uiRecordApi';
import FIELD_City from '@salesforce/schema/Store__c.City__c';
import FIELD_Country from '@salesforce/schema/Store__c.Country__c';
const fields = [FIELD_City, FIELD_Country];

export default class DeliveryDetailMap extends LightningElement {
	@api recordId;
	name;
	mapMarkers = [];
	error;
	
	@wire(getRecord, { recordId: '$recordId', fields })
	wiredMap({ error, data }) {
		if (error) {
			this.error=error;
		} else if (data) {
			// Get Map data
			const City = this._getDisplayValue(data, FIELD_City);
			const Country = this._getDisplayValue(data, FIELD_Country);
			// Transform location data into map markers
			this.mapMarkers = [{
				location: { City, Country },
				description: `Coords: ${City}, ${Country}`
			}];
		}
	}

	_getDisplayValue(data, field) {
		return getFieldDisplayValue(data, field) ? getFieldDisplayValue(data, field) : getFieldValue(data, field);
	}
}