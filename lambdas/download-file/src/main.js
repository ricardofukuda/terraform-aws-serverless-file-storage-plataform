var AWS = require('aws-sdk');
// Set the region 
AWS.config.update({region: 'us-east-1'});

// Create S3 service object
s3 = new AWS.S3({apiVersion: '2006-03-01'});

exports.handler =  async function(event, context) {
  var params = {Bucket: 'file-service-storage-12345', Key: 'mykey', Expires: 600};
  const promise = new Promise(function(resolve, reject) {
    s3.getSignedUrl('getObject', params, function (err, url) {
      if(err){
        reject(err)
      }
      console.log('The URL is', url);

      resolve({
        "statusCode": 200,
        "headers": {},
        "body": JSON.stringify({"url": url}),
        "isBase64Encoded": false
      })
    });
  })
  return promise
}