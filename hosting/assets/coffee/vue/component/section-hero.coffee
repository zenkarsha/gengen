Vue.component 'section-hero',
  template: """
    <div class="section hero">
      <div class="hero-wrapper">
        <div class="mobile-baker">
          <img src="/images/baker/static.png" />
        </div>
        <h2 class="slogan" v-text="$t('hero.slogan')"></h2>
        <div class="introduce">
          <p v-html="$t('hero.introduce')"></p>
        </div>
        <div class="buttons">
          <router-link :to="{name: 'create', params: {lang: $route.params.lang}}" class="button rounded">
            <i class="flaticon-plus-symbol padding-right"></i>
            ${$t('button.create_generator')}
          </router-link>
        </div>
      </div>
      <generator-baker></generator-baker>
    </div>
  """
