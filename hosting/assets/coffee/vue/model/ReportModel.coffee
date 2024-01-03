ReportModel =
  data: ->
    {
      model: report:
        write: (data, callback, error_callback) ->
          DB.collection('report').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
