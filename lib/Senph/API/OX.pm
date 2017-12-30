package Senph::API::OX;
use 5.026;

# ABSTRACT: Just another OX

use OX;
use OX::RouteBuilder::REST;
use Plack::Runner;
use Log::Any qw($log);

sub request_class {'Senph::API::Request'}

has 'comment_ctrl' => (
    is       => 'ro',
    isa      => 'Senph::API::Ctrl::Comment',
    required => 1,
);

router as {

    wrap 'Plack::Middleware::PrettyException';

    # API
    route '/api/comment/:site/:topic' => 'REST.comment_ctrl.topic';    # GET
    route '/api/comment/:site/:topic/:reply_to' =>
        'REST.comment_ctrl.reply';                                     # POST

    # called from mail, so has to be HTML (or init SPA?)
    route '/publish/:site/:topic/:comment_ident/:comment_secret' =>
        'comment_ctrl.publish';
    route '/delete/:site/:topic/:comment_ident/:comment_secret' =>
        'comment_ctrl.delete';

};

sub run {
    return shift->to_app;
}

__PACKAGE__->meta->make_immutable;
