
import { Octokit } from "@octokit/rest"
document.addEventListener("turbolinks:load", function() {
const octokit = new Octokit({
  auth: "352f1f578c4da9a7bc84eaf6df049a4a073ee058",
});
      $('.link').each(function() {
        if ($(this).children().attr('href').includes('gist.github.com')){
          var link = this
          var gist_array = $(this).children().attr('href').split('/')
          var gist_id = gist_array[gist_array.length - 1]
          var gist_content = octokit.gists.get({
            gist_id
          })
          .then(res => console.log(res.data.files(Object.keys(res.data.files)[0])))
        }

      })
  })
