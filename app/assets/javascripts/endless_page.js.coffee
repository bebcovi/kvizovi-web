jQuery ->

  $(window).scroll ->
    if $(".pagination").length > 0
      url = $(".pagination .next_page a").attr("href")
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 300
        $(".pagination").html $("<p>", class: "text-muted", text: "Učitavanje još kvizova...")
        $.getScript(url)

  $(window).scroll()
