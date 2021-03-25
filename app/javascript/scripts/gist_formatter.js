
import { Octokit } from "@octokit/rest"
document.addEventListener("turbolinks:load", function() {
  const octokit = new Octokit()

  $('.link').each(function() {
    if ($(this).children().attr('href').includes('gist.github.com')){
      var link = this
      var gist_array = $(this).children().attr('href').split('/')
      var gist_id = gist_array[gist_array.length - 1]
      octokit.gists.get({
        gist_id
      })
      .then(res => Object.entries(res.data.files).forEach(
        ([key, file]) => $(link).append(`<h5>Gist content:</h5> ${file.filename}: ${file.content}`)
      ))
    }

  })
})
