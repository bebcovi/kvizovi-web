jQuery ->

  if $(".pagination").length

    $(window).scroll ->
      url = $(".pagination .next_page a").attr("href")
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
        $(".pagination").text("Učitavanje još kvizova...")
        $.getScript(url)

    $(window).scroll()
