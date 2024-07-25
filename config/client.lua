return {
    requiredCops = 0,          -- The minimum number of cops required on duty to initiate a gun drop event.

    timeUntilDrop = 1,         -- The time in minutes it takes for the gun to be dropped after initiating contact with the pilot.

    loadModels = {             -- The list of models that need to be loaded for the drop event.
        'w_am_flare',          -- The model for the flare.
        'p_cargo_chute_s',     -- The model for the parachute attached to the crate.
        'ex_prop_adv_case_sm', -- The model for the crate containing the loot.
        'cuban800',            -- The model for the plane used to drop the crate.
        's_m_m_pilot_02'       -- The model for the pilot of the plane.
    },

    flareName = 'weapon_flare',                                  -- The name of the flare used to signal the drop.
    flareModel = 'w_am_flare',                                   -- The model for the flare.
    planeModel = 'cuban800',                                     -- The model for the plane that drops the crate.
    planePilotModel = 's_m_m_pilot_02',                          -- The model for the pilot flying the plane.
    parachuteModel = 'p_cargo_chute_s',                          -- The model for the parachute attached to the dropping crate.
    crateModel = 'ex_prop_adv_case_sm',                          -- The model for the crate containing the dropped.

    itemDrops = {                                                -- The configuration for items dropped based on the phone used.
        ['goldenphone'] = {                                      -- Items dropped when using the golden satellite phone.
            [1] = { name = 'WEAPON_CARBINERIFLE', amount = 1 },  -- A carbine rifle weapon.
            [2] = { name = 'WEAPON_ADVANCEDRIFLE', amount = 1 }, -- An advanced rifle weapon.
        },
        ['redphone'] = {                                         -- Items dropped when using the red satellite phone.
            [1] = { name = 'WEAPON_ASSAULTRIFLE', amount = 1 },  -- An assault rifle weapon.
        },
        ['greenphone'] = {                                       -- Items dropped when using the green satellite phone.
            [1] = { name = 'WEAPON_SMG', amount = 1 },           -- A submachine gun weapon.
        },
    },
}
