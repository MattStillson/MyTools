import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Devops70538Component } from './devops70538.component';

describe('Devops70538Component', () => {
  let component: Devops70538Component;
  let fixture: ComponentFixture<Devops70538Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Devops70538Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Devops70538Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
