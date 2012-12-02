###
Module for defining media type by url.

###

if "undefined" is typeof global
    window.semantics.urls  = {}
    exports               = window.semantics.urls
else
    exports               = module.exports


((exports) ->

  ###
  Try to guess content type by url.

  @param {String} url Url
  @return {String} type Content type, one of "unknown", "picture", "video"
  ###
  exports.getUrlType = (url) ->
    urlFromDomain = url.replace /^https?\:\/\//, ""
    videoUrls = ["youtube.com", "www.youtube.com", "youtu.be", "vimeo.com", "viddler.com",
                 "blip.tv", "rutube.ru", "smotri.com", "video.yandex.ru", "video.yandex.com"]

    picUrls = ["flickr.com", "twitpic.com", "instagr.am", "media.photobucket.com"]
    videoUrls.map (u) -> if 0 is urlFromDomain.indexOf u then return "video"
    picUrls.map (u) -> if 0 is urlFromDomain.indexOf u then "picture"
    return "unknown"

)(exports)
