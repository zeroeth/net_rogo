module DeerLandscapeFunctions
  
    HABITAT_ATTRIBUTES = { open_water:                {suitability: -1, forest_type_index: 0,   forest: 0},
                         developed_open_space:        {suitability: 1,  forest_type_index: 0,   forest: 0},
                         developed_low_intensity:     {suitability: 1,  forest_type_index: 0,   forest: 0},
                         developed_medium_intensity:  {suitability: 0,  forest_type_index: 0,   forest: 0},
                         developed_high_intensity:    {suitability: 0,  forest_type_index: 0,   forest: 0},
                         barren:                      {suitability: 0,  forest_type_index: 0,   forest: 0},
                         deciduous:                   {suitability: 1,  forest_type_index: 0,   forest: 1},
                         coniferous:                  {suitability: 1,  forest_type_index: 1,   forest: 1},
                         mixed:                       {suitability: 1,  forest_type_index: 0.5, forest: 1},
                         dwarf_scrub:                 {suitability: 1,  forest_type_index: 0,   forest: 0},
                         shrub_scrub:                 {suitability: 1,  forest_type_index: 0,   forest: 0},
                         grassland_herbaceous:        {suitability: 1,  forest_type_index: 0,   forest: 0},
                         pasture_hay:                 {suitability: 1,  forest_type_index: 0,   forest: 0},
                         cultivated_crops:            {suitability: 1,  forest_type_index: 0,   forest: 0},
                         forested_wetland:            {suitability: 1,  forest_type_index: 0,   forest: 1},
                         emergent_herbaceous_wetland: {suitability: 1,  forest_type_index: 0,   forest: 0},
                         excluded:                    {suitability: -1, forest_type_index: 0,   forest: 0}}
  
  
  def assess_thermal_cover
    #forest_composition_index x forest_structure_index x site_productivity_index
    forest_type_index = HABITAT_ATTRIBUTES[self.land_cover_class][:forest_type_index]
    if forest_type_index > 0
      thermal_index = forest_composition_index * forest_structure_index * site_productivity_index
    else
      thermal_index = 0
    end
  end

 def forest_composition_index
   forest_type_index = HABITAT_ATTRIBUTES[patch.land_cover_class][:forest_type_index]
   # TODO: currently cannot differentiate between conifer types; would be useful to implement general moisture regime (mesic/xeric)
     # Northern Hemlock, White Cedar = 1 (lowland/mesic conifers)
     # spruce and fir = 0.8 (woody wetlands)
     # pine = 0.4 (upland/xeric conifers)
   coniferous_species_index = 1
   forest_composition_index = forest_type_index * coniferous_species_index
 end


 def forest_structure_index
   # TODO: finish this off when access to forest data is available
   basal_area_index = 1
     # 0 - 30.49 ft: 0
     # 30.49 - 100.19: 0.5
     # > 100.19 : 1
   diameter_index = 1
   canopy_cover_index = 1
   age_structure_index = 1
   forest_structure_index = (2 * ((basal_area_index + canopy_cover_index + diameter_index) / 3) + age_structure_index) / 3
 end

 def basal_area_index
   if 
     (0..30.49).include? patch.basal_area
     0
   elsif
     (30.49..100.19).include? patch.basal_area
     0.5
   else
     patch.basal_area > 100.19
     1
   end
 end


 def assess_fall_winter_food_potential
    #forest_composition_index x forest_structure_index x site_productivity_index
    forest_index = HABITAT_ATTRIBUTES[self.land_cover_class][:forest]
    if forest_index > 0
      fall_winter_food_index = (2 * browse_index + mast_index) * 3 * site_productivity_index 
    else
      fall_winter_food_index = 0
    end
 end


 def browse_index
   1
   #TODO: have to link to species-specific traits; upland/lowland x lcc?
 end

 
 def mast_index
   1
   #TODO: also species specific (oak and beech); upland/lowland x lcc?
 end


 def assess_spring_summer_food_potential
    #forest_composition_index x forest_structure_index x site_productivity_index
    forest_index = HABITAT_ATTRIBUTES[self.land_cover_class][:forest]
    if forest_index > 0
      spring_summer_food_index = vegetation_type_index * successional_stage_index * site_productivity_index
    else
      spring_summer_food_index = 0
    end
 end


 def vegetation_type_index
   # upland deciduous and mixed = 1
   # upland coniferous = 0.4
   # lowland (aquatic emergent plants) = 0.2 - probably just wetlands (woody and herbacious)
  if self.land_cover_class = :deciduous or :mixed
     1
   elsif self.land_cover_class = :coniferous
     0.4
   elsif self.land_cover_class = :forested_wetland or :emergent_herbacious_wetlands
     0.2
   else
     0
   end
 end


 def successional_stage_index
   # TODO: these include bedding usage? wtf?
   # upland deciduous and mixed or lowland early successional = 1.0
   # upland deciduous and mixed or lowland mid-successional   = 0.6
   # upland deciduous and mixed or lowland late-successional  = 0.2
   # upland coniferous early- to mid-successional             = 1.0
   # upland coniferous late-successional                      = 0.5
   1
 end

 
 def site_productivity_index
   # TODO: tie max_site_index to stricter number
   max_site_index = 100
   self.site_index/max_site_index 
 end
end
