function sendEmail(link) {
  try {
    const email = Session.getActiveUser().getEmail();

    var cutePhotoBlob = UrlFetchApp
                        .fetch(link)
                        .getBlob()
                        .setName("cutePhotoBlob");

    const subject = "Here's a cute animal";
    const body = "<img src='cid:nlPhoto' />";

    GmailApp.sendEmail('jeffreyhung@hotmail.com.tw', subject, "",
              { htmlBody: body, inlineImages:
                                {
                                  nlPhoto: cutePhotoBlob,
                                }
              });

  } catch (err) {
    Logger.log('Failed with error %s', err.message);
  }
}

function fetchURL(url) {
    var response = UrlFetchApp.fetch(url);
    return response.getContentText();
}

function getURL() {
  const dog_api = 'https://random.dog/woof.json';
  const cat_api = 'https://api.thecatapi.com/v1/images/search';
  random_number = Math.round(Math.random());
    if (random_number) {
      return (JSON.parse(fetchURL(dog_api))).url;
    }else {
      return (JSON.parse(fetchURL(cat_api)))[0].url;
  }

}

function main() {
  sendEmail(getURL());
}