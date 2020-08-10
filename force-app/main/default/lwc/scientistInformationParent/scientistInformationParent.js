import { LightningElement,track } from 'lwc';

export default class ScientistInformationParent extends LightningElement {

@track selectedScientistInformation;


    scientistData = [
        {scientistName:'Albert Einstein', scientistdescription:'Albert Einstein was a German-born theoretical physicist who developed the theory of relativity, one of the two pillars of modern physics. His work is also known for its influence on the philosophy of science'},
        {scientistName:'Marie Curie', scientistdescription:'Marie Skłodowska Curie, born Maria Salomea Skłodowska, was a Polish and naturalized-French physicist and chemist who conducted pioneering research on radioactivity.'},
        {scientistName:'Galileo Galilei', scientistdescription:'Galileo di Vincenzo Bonaulti de Galilei was an Italian astronomer, physicist and engineer, sometimes described as a polymath, from Pisa. Galileo has been called the "father of observational astronomy", the "father of modern physics", the "father of the scientific method", and the "father of modern science".'},
        {scientistName:'Stephen Hawking', scientistdescription:'Stephen William Hawking CH CBE FRS FRSA was an English theoretical physicist, cosmologist, and author who was director of research at the Centre for Theoretical Cosmology at the University of Cambridge at the time of his death.'},
        {scientistName:'Alexander Graham Bell', scientistdescription:'Alexander Graham Bell was a Scottish-born American inventor, scientist, and engineer who is credited with inventing and patenting the first practical telephone. He also co-founded the American Telephone and Telegraph Company in 1885.'}
    ];

    onSelectHandler(event){
        // in our child we have included all our details in the detail property
        const scientistInformation = event.detail;
        this.selectedScientistInformation = scientistInformation.scientistdescription;

    }

}