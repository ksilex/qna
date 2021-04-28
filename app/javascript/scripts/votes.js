$(document).on('turbolinks:load', function(){
  $(document).on('ajax:success', function(e){
      var xhr = e.detail[0]
      if (!xhr.vote_type) return
      var sum = xhr.sum
      var resource = xhr.resource
      var resource_id = xhr.resource_id
      var vote_type = xhr.vote_type

      $('.' + resource + '.' + resource_id + ' .vote-count').html(sum)

      if (vote_type == 'upvote') {
        $(`.${resource}.${resource_id} .upvote-link`).attr('href', `/${resource}s/${resource_id}/unvote`)
        $(`.${resource}.${resource_id} .upvote-link`).attr('data-method', 'delete')
        $(`.${resource}.${resource_id} .upvote-link`).addClass('active')

        $(`.${resource}.${resource_id} .downvote-link`).attr('href', `/${resource}s/${resource_id}/downvote`)
        $(`.${resource}.${resource_id} .downvote-link`).attr('data-method', 'post')
        $(`.${resource}.${resource_id} .downvote-link`).removeClass('active')
      }

      if (vote_type == 'downvote') {
        $(`.${resource}.${resource_id} .downvote-link`).attr('href', `/${resource}s/${resource_id}/unvote`)
        $(`.${resource}.${resource_id} .downvote-link`).attr('data-method', 'delete')
        $(`.${resource}.${resource_id} .downvote-link`).addClass('active')

        $(`.${resource}.${resource_id} .upvote-link`).attr('href', `/${resource}s/${resource_id}/upvote`)
        $(`.${resource}.${resource_id} .upvote-link`).attr('data-method', 'post')
        $(`.${resource}.${resource_id} .upvote-link`).removeClass('active')
      }

      if (vote_type == 'unvote') {
        $(`.${resource}.${resource_id} .downvote-link`).attr('href', `/${resource}s/${resource_id}/downvote`)
        $(`.${resource}.${resource_id} .downvote-link`).attr('data-method', 'post')
        $(`.${resource}.${resource_id} .downvote-link`).removeClass('active')

        $(`.${resource}.${resource_id} .upvote-link`).attr('href', `/${resource}s/${resource_id}/upvote`)
        $(`.${resource}.${resource_id} .upvote-link`).attr('data-method', 'post')
        $(`.${resource}.${resource_id} .upvote-link`).removeClass('active')
      }
  })
  .on('ajax:error', function (e) {
    var xhr = e.detail[0]
    var errors = xhr.errors
    var resource = xhr.resource
    var resource_id = xhr.resource_id
    $.each(errors, function(index, value) {
      $(`.${resource}-body.${resource_id}`).before(`
      <div class="alert alert-danger alert-dismissible fade show">
        ${value}
        <button aria-label="Close" class="btn-close" data-bs-dismiss="alert" type="button"></button>
      </div>`)
    })

})
});
