var gitalk = new Gitalk({
    id: 'location.hash',
    clientID: '05cb0f1a7375170c1450',
    clientSecret: '0549cacd7883c2391f6ce5bc5d733453612d96ef',
    repo: 'neet11.github.io',
    id: window.location.pathname,
    owner: 'neet11',
    admin: ['neet11'],
    perPage: 50,
    distractionFreeMode: false,
})
gitalk.render('gitalk-container');
