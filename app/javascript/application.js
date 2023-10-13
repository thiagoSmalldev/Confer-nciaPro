// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require jquery3
//= require popper
//= require bootstrap-sprockets

$(document).ready(function() {
	// Mostrar os botões quando o mouse passa por cima da linha da tabela
	$('tr').hover(function() {
		$(this).find('a, button').show();
	}, function() {
		$(this).find('a, button').hide();
	});
});