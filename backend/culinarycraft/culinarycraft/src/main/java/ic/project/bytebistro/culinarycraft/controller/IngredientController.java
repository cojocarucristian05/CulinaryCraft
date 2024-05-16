package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.service.IngredientService;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("${apiVersion}/ingredients")
public class IngredientController {
    private final IngredientService ingredientService;

    public IngredientController(IngredientService ingredientService) {
        this.ingredientService = ingredientService;
    }

    @GetMapping()
    public ResponseEntity<Page<IngredientDTO>> getIngredients(@RequestParam int pageNumber,
                                                              @RequestParam int pageSize) {
        return new ResponseEntity<>(ingredientService.getIngredients(pageNumber, pageSize), HttpStatus.OK);
    }

    @GetMapping("/sort=name")
    public ResponseEntity<Page<IngredientDTO>> getIngredientsSortedByName(@RequestParam int pageNumber,
                                                              @RequestParam int pageSize) {
        return new ResponseEntity<>(ingredientService.getIngredientsSortedByName(pageNumber, pageSize), HttpStatus.OK);
    }

    @GetMapping("/sort=name/desc")
    public ResponseEntity<Page<IngredientDTO>> getIngredientsSortedByNameDescending(@RequestParam int pageNumber,
                                                                          @RequestParam int pageSize) {
        return new ResponseEntity<>(ingredientService.getIngredientsSortedByNameDescending(pageNumber, pageSize), HttpStatus.OK);
    }
}
