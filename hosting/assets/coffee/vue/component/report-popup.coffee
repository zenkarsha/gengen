Vue.component 'report-popup',
  template: """
    <div class="report-container">
      <button type="button" :class="class_name" v-on:click="show_popup">
        <i class="flaticon-warning padding-right"></i>
        ${$t('button.report')}
      </button>
      <div class="popup-container mobile-fullscreen" v-show="popup_on">
        <div class="popup-wrapper">
          <div class="popup-content">
            <h2 v-text="$t('button.report')"></h2>
            <div class="report-form">
              <div class="report-reason">
                <h3 v-text="$t('title.report_reason')"></h3>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_1')"> ${$t('report.reason_1')}</label>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_2')"> ${$t('report.reason_2')}</label>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_3')"> ${$t('report.reason_3')}</label>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_4')"> ${$t('report.reason_4')}</label>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_5')"> ${$t('report.reason_5')}</label>
                <label><input type="radio" v-model="reason" :value="$t('report.reason_6')"> ${$t('report.reason_6')}</label>
              </div>
              <textarea v-model="message" rows="8" :placeholder="$t('message.report_issue')"></textarea>
            </div>
          </div>
          <div class="popup-footer gray">
            <button type="button" class="button gray" v-on:click="close_popup()" v-text="$t('button.cancel')"></button>
            <button type="button" class="button" v-on:click="send_report()">
              ${$t('button.done')}
              <i class="flaticon-tick padding-left"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  """

  mixins: [
    UserMixin
    ReportModel
  ]

  data: ->
    {
      popup_on: false
      reason: ''
      message: ''
    }

  props:
    model_name: type: String, default: ''
    doc_id: type: String, default: ''
    class_name: type: String, default: 'button gray mini'

  methods:
    show_popup: ->
      @popup_on = true
      lock_html()

    close_popup: ->
      if @popup_on is true
        @popup_on = false
        @reason = ''
        @message = ''
        unlock_html()

    send_report: ->
      uid = if @user and @user.uid then @user.uid else 'anonymous'
      data =
        model_name: @model_name
        doc_id: @doc_id
        uid: uid
        url: window.location.href
        reason: @reason
        message: @message
        timestamp: timestamp()

      gogo.start()
      self = @
      @model.report.write data, (result) ->
        gogo.stop()
        noty self.$t('alert.report_success'), 'info'
        self.close_popup()
      , (error) ->
        xx error
        gogo.stop()
        noty self.$t('alert.something_went_wrong'), 'error'
        self.close_popup()
