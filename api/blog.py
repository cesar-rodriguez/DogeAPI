#!/usr/bin/python3

import uuid

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from models import models
from schema import schemas


def get_all(db: Session):
    """
    Get all blogs

    Args:
        db (Session): Database session

    Returns:
        List[models.Blog]: List of blogs
    """
    return db.query(models.Blog).all()


def create(request: schemas.Blog, db: Session):
    """
    Create a new blog

    Args:
        request (schemas.Blog): Blog object
        db (Session): Database session

    Returns:
        models.Blog: Blog object
    """
    s3_key = str(uuid.uuid4())  # Generating a unique UUID for the S3 key

    new_blog = models.Blog(s3_key=s3_key, user_id=1, title=request.title)
    new_blog.body = request.body

    db.add(new_blog)
    db.commit()
    db.refresh(new_blog)
    return new_blog


def destroy(id: int, db: Session):
    """
    Delete a blog

    Args:
        id (int): Blog id
        db (Session): Database session

    Raises:
        HTTPException: 404 not found

    Returns:
        str: Success message
    """
    blog_to_delete = db.query(models.Blog).filter(models.Blog.id == id)

    if not blog_to_delete.first():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Blog with id {id} not found.",
        )
    blog_to_delete.delete(synchronize_session=False)
    db.commit()
    return {"done"}


def update(id: int, request: schemas.Blog, db: Session):
    """
    Update a blog

    Args:
        id (int): Blog id
        request (schemas.Blog): Blog object
        db (Session): Database session

    Raises:
        HTTPException: 404 not found

    Returns:
        models.Blog: Blog object
    """
    blog = db.query(models.Blog).filter(models.Blog.id == id)
    if not blog.first():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail=f"Blog with id {id} not found"
        )
    blog.update(request.__dict__)
    db.commit()
    return "updated"


def show(id: int, db: Session):
    """
    Get a blog

    Args:
        id (int): Blog id
        db (Session): Database session

    Raises:
        HTTPException: 404 not found

    Returns:
        models.Blog: Blog object
    """
    blog = db.query(models.Blog).filter(models.Blog.id == id).first()
    if blog:
        return blog
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Blog with the id {id} is not available",
        )
