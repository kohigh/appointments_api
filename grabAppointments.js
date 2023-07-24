const axios = require('axios');

const apiUrl = 'http://localhost:3000/availabilities?dentist_id=111&from=2021-01-04&to=2021-01-06';
const token = 'Token 99vN03JCcaTDyQV-UgPjkw';

const headers = {
    'Authorization': token,
};

axios.get(apiUrl, { headers })
    .then(response => {
        console.log('Appointments:', response.data);
    })
    .catch(error => {
        console.error('Error fetching appointments:', error.message);
    });
