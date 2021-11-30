var gitalk = new Gitalk({
    id: 'location.hash',
    clientID: '05cb0f1a7375170c1450',
    clientSecret: '096dd09023fdab671aa4b5bdd4a663d8e4837ca9',
    repo: 'neet11.github.io',
    owner: 'neet11',
    admin: ['neet11'],
    perPage: 50,
    distractionFreeMode: false,
})
gitalk.render('gitalk-container');

