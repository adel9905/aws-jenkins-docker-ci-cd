const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send(`
    <h1>Jenkins Automated Deployment Works 🚀</h1>
    <p>Version: <strong>${process.env.BUILD_NUMBER || 'local-dev'}</strong></p>
    <p>Deployed using Jenkins, Docker and Terraform on AWS EC2 (Ubuntu).</p>
  `);
});

app.listen(port, () => {
    console.log(`App listening on port ${port}`);
});