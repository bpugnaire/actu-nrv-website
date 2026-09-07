(() => {
    const button = document.querySelector('[data-nav-toggle]');
    const navigation = document.querySelector('[data-navigation]');

    if (button && navigation) {
        button.addEventListener('click', () => {
            const isOpen = button.getAttribute('aria-expanded') === 'true';
            button.setAttribute('aria-expanded', String(!isOpen));
            navigation.classList.toggle('is-open', !isOpen);
            document.body.classList.toggle('nav-is-open', !isOpen);
        });
    }

    const currentDate = document.querySelector('[data-current-date]');
    if (currentDate) {
        const formatted = new Intl.DateTimeFormat('fr-FR', {
            weekday: 'long', day: 'numeric', month: 'long', year: 'numeric'
        }).format(new Date());
        currentDate.textContent = formatted.charAt(0).toUpperCase() + formatted.slice(1);
    }
})();
