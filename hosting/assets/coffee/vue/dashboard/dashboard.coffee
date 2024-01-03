Vue.component 'dashboard',
  template: """
    <div class="template-wrapper">
      <div class="container">
        <div class="section page-header">
          <div class="header-wrapper">
            <h1>Dashboard</h1>
          </div>
        </div>
      </div>
      <div class="section">
        <div class="container two-column">
          <div class="side-nav">
            <button type="button" class="button full-width small" v-on:click="current = 'gen'">Generators</button>
            <button type="button" class="button full-width small" v-on:click="current = 'feed_post'">Posts</button>
            <button type="button" class="button full-width small" v-on:click="current = 'admin_recommend'">Admin recommend</button>
          </div>
          <div class="main-content" ref="main_content">
            <div class="admin-recommend-form" v-if="current == 'admin_recommend'">
              <div class="form-group">
                <h3>Add new recommend generator</h3>
                <input type="text" v-model="recommend_gid" placeholder="Please enter generator id" />
                <button type="button" class="button small" v-on:click="add_recommend_gen">
                  <i class="flaticon-plus-symbol padding-right"></i> Add
                </button>
              </div>
            </div>
            <ul class="link-list">
              <li v-for="item in list" class="list-item" v-if="list.length > 0">
                <div class="image">
                  <img :src="w_square(item.data().cover, 64)" v-if="current == 'gen' && item.data().cover" />
                  <img :src="w_square(item.data().image, 64)" v-if="current == 'feed_post' && item.data().image" />
                  <img :src="w_square(item.data().cover, 64)" v-if="current == 'admin_recommend' && item.data().cover" />
                </div>
                <div class="link">
                  <router-link :to="{name: current, params: {lang: $route.params.lang, gid: item.id}}" v-if="current == 'gen'" target="_blank">
                    <i class="flaticon-link padding-right"></i> ${item.data().title}
                  </router-link>
                  <router-link :to="{name: current, params: {lang: $route.params.lang, pid: item.data().pid}}" v-if="current == 'feed_post'" target="_blank">
                    <i class="flaticon-link padding-right"></i> ${item.data().image}
                  </router-link>
                  <router-link :to="{name: 'gen', params: {lang: $route.params.lang, gid: item.id}}" v-if="current == 'admin_recommend'" target="_blank">
                    <i class="flaticon-link padding-right"></i> ${item.data().title}
                  </router-link>
                </div>
                <div class="buttons">
                  <button type="button" class="button icon danger" v-on:click="ban(item)" v-if="current == 'gen' || current == 'feed_post'">
                    <i class="flaticon-warning padding-right"></i> Ban
                  </button>
                  <button type="button" class="button icon danger" v-on:click="delete_recommend_item(item)" v-if="current == 'admin_recommend'">
                    <i class="flaticon-garbage padding-right"></i> Del
                  </button>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  """

  data: ->
    {
      current: ''
      recommend_gid: ''
      list: []
    }

  mounted: ->
    @current = 'admin_recommend'

  methods:
    load_gen_list: ->
      self = @
      @list = []
      DB.collection('generators').orderBy('timestamp', 'desc').where('flagged', '==', true).where('banned', '==', false).where('deleted', '==', false).get().then((results) ->
        self.list = results.docs
      ).catch (error) ->
        xx error

    load_feed_list: ->
      self = @
      @list = []
      DB.collection('feed').orderBy('created_at', 'desc').where('flagged', '==', true).where('banned', '==', false).where('deleted', '==', false).get().then((results) ->
        self.list = results.docs
      ).catch (error) ->
        xx error

    load_admin_recommend_list: ->
      self = @
      @list = []
      DB.collection('admin_recommend').orderBy('created_at', 'desc').get().then((results) ->
        if results.docs.length > 0
          for item in results.docs
            DB.collection('generators').doc(item.data().gid).get().then((result) ->
              self.list.push result
            ).catch (error) ->
              xx error
      ).catch (error) ->
        xx error

    ban: (item) ->
      self = @
      if @current is 'gen'
        DB.collection('generators').doc(item.id).update(banned: true).then((result) ->
          DB.collection('generators_count').doc(item.id).update(banned: true).then((result) ->
            index = self.list.indexOf item
            self.list.splice(index, 1)
          ).catch (error) ->
            xx error
        ).catch (error) ->
          xx error
      else if @current is 'feed_post'
        DB.collection('feed').doc(item.id).update(banned: true).then((result) ->
          DB.collection('feed_count').doc(item.id).update(banned: true).then((result) ->
            index = self.list.indexOf item
            self.list.splice(index, 1)
          ).catch (error) ->
            xx error
        ).catch (error) ->
          xx error

    add_recommend_gen: ->
      self = @
      data =
        gid: @recommend_gid
        created_at: timestamp()
      DB.collection('admin_recommend').doc(@recommend_gid).set(data).then((result) ->
        self.recommend_gid = ''
        self.load_admin_recommend_list()
        noty 'Success!', 'success'
        scroll_top()
      ).catch (error) ->
        xx error

    delete_recommend_item: (item) ->
      self = @
      DB.collection('admin_recommend').doc(item.id).delete().then((result) ->
        self.load_admin_recommend_list()
        noty 'Success!', 'success'
        scroll_top()
      ).catch (error) ->
        xx error


  watch:
    current: (value) ->
      if value is 'gen'
        @load_gen_list()
      else if value is 'feed_post'
        @load_feed_list()
      else if value is 'admin_recommend'
        @load_admin_recommend_list()
