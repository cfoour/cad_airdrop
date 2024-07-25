fx_version 'cerulean'
game 'gta5'

name 'cad_airdrop'
author 'cFour'
description 'Items Air drop system for Illegal'
version '2.0.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

files {
    'locales/*.json',
    'config/*.lua',
}


lua54 'yes'
use_fxv2_oal 'yes'
--use_experimental_fxv2_oal 'yes'
