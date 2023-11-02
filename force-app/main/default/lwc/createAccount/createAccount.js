import { LightningElement } from 'lwc';
import createacc from '@salesforce/apex/createaccount.createacc';
export default class CreateAccount extends LightningElement {
  value = 'Chemical';
name;
phone;
get options() {
        return [
            { label: 'Agriculture', value: 'Agriculture' },
            { label: 'Banking', value: 'Banking' },
            { label: 'Chemical', value: 'Chemical' },
        ];
    }
    handlename(event){
this.name=event.target.value;
console.log(this.name);
    }
    handlephone(event){
this.phone=event.target.value;
console.log(this.phone);
    }
    handleindustry(event){
this.value = event.detail.value;
console.log(this.value);
    }
    handleclick(){
        console.log('fired');
    createacc({AccName:this.name,Phonenumber:this.phone,Industry:this.value}).then(result=>{
        alert('Account created successfully with Id '+result.Id);
 
 
    }).catch(error=>{});
    }
}